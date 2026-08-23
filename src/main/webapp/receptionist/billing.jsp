<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.config.DatabaseConnection, java.sql.*, java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%
    if(session.getAttribute("user") == null || !"RECEPTIONIST".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=Access Denied: Receptionist Session Required");
        return;
    }
    
    // Get Current Today's Date
    LocalDate today = LocalDate.now();
    DateTimeFormatter dbDateFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd");
%>
<jsp:include page="../components/header.jsp" />

<!-- jsPDF Library for Client-Side PDF Generation -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

<!-- Advanced Design Token Underlays -->
<style>
    .glass-billing-hud {
        background: rgba(224, 242, 254, 0.75);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.5);
        box-shadow: 0 8px 32px 0 rgba(15, 23, 42, 0.08);
    }
    .glass-ledger-card {
        background: rgba(255, 255, 255, 0.85);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.6);
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    }
</style>

<!-- High-Fidelity Container -->
<div class="relative min-h-[88vh] rounded-3xl overflow-hidden p-4 sm:p-6 lg:p-10 border border-slate-200/60 shadow-xl bg-cover bg-center transition-all duration-700"
     style="background-image: url('https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=1920&q=80');">
    
    <div class="absolute inset-0 z-0 bg-gradient-to-tr from-slate-950/85 via-slate-900/40 to-emerald-950/20"></div>

    <div class="relative z-10 max-w-5xl mx-auto space-y-6">

        <!-- Header -->
        <div class="glass-billing-hud rounded-2xl border border-white/40 p-5 sm:p-6 shadow-lg shadow-slate-900/10">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                <div>
                    <div class="flex items-center gap-2">
                        <span class="inline-flex h-6 w-6 items-center justify-center rounded-md bg-emerald-600 text-white shadow-sm shadow-emerald-600/20">
                            <i class="fa-solid fa-receipt text-[11px]"></i>
                        </span>
                        <h1 class="text-xl font-black tracking-tight text-slate-900 uppercase sm:text-2xl">Financial Settlement Center</h1>
                    </div>
                    <p class="mt-1 text-xs sm:text-sm font-medium text-slate-500">Collect consultation fees, issue dynamic invoice receipts, and track payment archives.</p>
                </div>
                
                <a href="dashboard.jsp" class="inline-flex items-center gap-2 self-start md:self-center rounded-xl border border-slate-200 bg-white/90 px-4 py-2 text-xs font-bold text-slate-700 shadow-sm transition-all hover:bg-slate-50 hover:text-slate-900 active:scale-[0.98] backdrop-blur-sm">
                    <i class="fa-solid fa-arrow-left-long text-slate-400"></i>
                    <span>Dashboard View</span>
                </a>
            </div>
        </div>

        <!-- Filtration Matrix Toolbar -->
        <div class="glass-billing-hud flex flex-col sm:flex-row items-center justify-between gap-4 rounded-2xl border border-white/40 p-4 shadow-md">
            <div class="relative w-full sm:max-w-md group">
                <input type="text" id="billingSearch" onkeyup="filterBillingTable()" 
                       placeholder="Quick filter by patient name or appointment ID..." 
                       class="w-full rounded-xl border border-slate-200/80 bg-slate-50/60 py-2.5 pl-4 pr-10 text-xs font-bold text-slate-700 placeholder-slate-400 focus:border-emerald-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-emerald-500 transition-all shadow-inner" />
                       
                <span class="absolute inset-y-0 right-0 z-10 flex items-center pr-3.5 pointer-events-none text-slate-400 group-focus-within:text-emerald-500 transition-colors">
                    <i class="fa-solid fa-magnifying-glass text-xs"></i>
                </span>
            </div>        
            <div class="flex items-center gap-2 self-stretch sm:self-auto justify-end rounded-xl bg-rose-50/90 px-3.5 py-2 text-xs font-black text-rose-700 border border-rose-100/80 shadow-sm backdrop-blur-sm">
                <i class="fa-solid fa-circle-dollar-to-slot text-rose-500 text-sm animate-pulse"></i>
                <span class="tracking-wide uppercase text-[10px]">Awaiting Payment: <span id="pendingCounter" class="font-black font-mono text-xs bg-rose-200/60 px-1.5 py-0.5 rounded ml-0.5">0</span> Bills</span>
            </div>
        </div>

        <!-- Master Ledger Data Table -->
        <div class="glass-ledger-card overflow-hidden rounded-2xl border border-white/50 shadow-2xl flex flex-col justify-between min-h-[450px]">
            <div class="overflow-x-auto">
                <table class="w-full border-collapse text-left text-xs text-slate-600">
                    <thead>
                        <tr class="border-b border-slate-200 bg-slate-100/60 font-black uppercase tracking-wider text-slate-400 text-[10px]">
                            <th scope="col" class="px-6 py-4.5">App No</th>
                            <th scope="col" class="px-6 py-4.5">Patient Profile</th>
                            <th scope="col" class="px-6 py-4.5">Treatments & Add-ons</th>
                            <th scope="col" class="px-6 py-4.5">Amount (Inc. 20% Tax)</th>
                            <th scope="col" class="px-6 py-4.5">Status & Schedule</th>
                            <th scope="col" class="px-6 py-4.5 text-center">Action Framework</th>
                        </tr>
                    </thead>
                    <tbody id="billingTableBody" class="divide-y divide-slate-100 font-medium">
                    <%
                        int pendingRecordCount = 0;
                        int totalRecordCount = 0;
                        try {
                            Connection conn = DatabaseConnection.getInstance().getConnection();
                            String sql = "SELECT a.id, a.appointment_number, p.name AS patient_name, a.treatment_type, " +
                                         "a.consultation_fee, a.appointment_date, a.appointment_time, a.payment_status, " +
                                         "COALESCE(SUM(ad.addon_price), 0) AS total_addons, " +
                                         "GROUP_CONCAT(CONCAT(ad.addon_name, ' (', ad.addon_price, ' LKR)') SEPARATOR '||') AS addon_details " +
                                         "FROM appointments a " +
                                         "JOIN patients p ON a.patient_id = p.id " +
                                         "LEFT JOIN appointment_addons ad ON a.id = ad.appointment_id " +
                                         "GROUP BY a.id " +
                                         "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
                            
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery(sql);
                            
                            while(rs.next()) {
                                totalRecordCount++;
                                String paymentStatus = rs.getString("payment_status");
                                Date appDateRaw = rs.getDate("appointment_date");
                                LocalDate appDate = appDateRaw.toLocalDate();
                                
                                // Check if appointment date has arrived or passed
                                boolean isDateReached = !appDate.isAfter(today);

                                if("PENDING".equalsIgnoreCase(paymentStatus)) {
                                    pendingRecordCount++;
                                }
                                
                                double baseFee = rs.getDouble("consultation_fee");
                                double addonFee = rs.getDouble("total_addons");
                                double subtotal = baseFee + addonFee;
                                double totalFeeWithTax = subtotal * 1.20; 
                                
                                String escapedPatientName = rs.getString("patient_name").replace("'", "\\'").replace("\"", "\\\"");
                                String escapedTreatmentType = rs.getString("treatment_type").replace("'", "\\'").replace("\"", "\\\"");
                                String addonDetails = rs.getString("addon_details") != null ? rs.getString("addon_details").replace("'", "\\'").replace("\"", "\\\"") : "";
                    %>
                        <tr class="billing-row transition-all duration-200 hover:bg-emerald-50/40 group" data-status="<%= paymentStatus %>">
                            <!-- App Number Badge -->
                            <td class="whitespace-nowrap px-6 py-4 font-bold text-slate-900">
                                <span class="inline-flex items-center gap-1 rounded-lg bg-slate-100 border border-slate-300/60 px-2 py-1 text-[11px] font-mono font-bold text-slate-700 shadow-inner group-hover:bg-white transition-colors">
                                    <%= rs.getString("appointment_number") %>
                                </span>
                            </td>
                            
                            <!-- Patient Name -->
                            <td class="whitespace-nowrap px-6 py-4 text-sm font-black text-slate-900 searchable-patient group-hover:text-emerald-950 transition-colors">
                                <%= rs.getString("patient_name") %>
                            </td>
                            
                            <!-- Base Treatment + Add-ons -->
                            <td class="px-6 py-4 text-slate-700">
                                <div class="flex flex-col gap-1">
                                    <div class="flex items-center gap-2">
                                        <div class="flex h-6 w-6 items-center justify-center rounded-md bg-slate-100 text-[10px] text-slate-500 border border-slate-200 group-hover:bg-emerald-600 group-hover:text-white transition-all">
                                            <i class="fa-solid fa-tooth"></i>
                                        </div>
                                        <span class="font-bold tracking-wide"><%= rs.getString("treatment_type") %></span>
                                    </div>
                                    <% if (!addonDetails.isEmpty()) { 
                                        String[] addonsArr = addonDetails.split("\\|\\|");
                                        for (String addon : addonsArr) {
                                    %>
                                        <div class="text-[10px] font-semibold text-orange-600 pl-8 flex items-center gap-1">
                                            <i class="fa-solid fa-plus text-[8px]"></i> <%= addon %>
                                        </div>
                                    <% 
                                        }
                                    } 
                                    %>
                                </div>
                            </td>
                            
                            <!-- Fee Breakdown -->
                            <td class="whitespace-nowrap px-6 py-4 font-mono text-sm font-black text-slate-800">
                                <div class="flex flex-col">
                                    <span class="text-[10px] text-slate-400 font-sans font-normal">Base: <%= String.format("%,.2f", baseFee) %> | Extra: <%= String.format("%,.2f", addonFee) %></span>
                                    <span class="<%= "PAID".equalsIgnoreCase(paymentStatus) ? "text-emerald-600" : "text-rose-600" %>"><%= String.format("%,.2f LKR", totalFeeWithTax) %></span>
                                </div>
                            </td>
                            
                            <!-- Status & Schedule -->
                            <td class="whitespace-nowrap px-6 py-4 text-slate-500 text-[11px]">
                                <div class="flex flex-col gap-1">
                                    <span class="status-badge inline-flex items-center gap-1 w-max px-2 py-0.5 rounded-full text-[9px] font-black uppercase tracking-wider <%= "PAID".equalsIgnoreCase(paymentStatus) ? "bg-emerald-100 text-emerald-800" : "bg-rose-100 text-rose-800" %>">
                                        <i class="fa-solid <%= "PAID".equalsIgnoreCase(paymentStatus) ? "fa-circle-check text-emerald-600" : "fa-clock text-rose-600" %>"></i>
                                        <span><%= paymentStatus %></span>
                                    </span>
                                    <span class="font-bold text-slate-700 flex items-center gap-1">
                                        <i class="fa-regular fa-calendar text-[10px] text-slate-400"></i><%= appDateRaw %>
                                    </span>
                                </div>
                            </td>
                            
                            <!-- Actions Logic -->
                            <td class="whitespace-nowrap px-6 py-4 text-center">
                                <% if ("PAID".equalsIgnoreCase(paymentStatus)) { %>
                                    <!-- Already Settled -> Show Download Button -->
                                    <button type="button" 
                                            onclick="generateInvoicePDF('<%= rs.getString("appointment_number") %>', '<%= escapedPatientName %>', '<%= escapedTreatmentType %>', <%= baseFee %>, <%= addonFee %>, <%= totalFeeWithTax %>, '<%= appDateRaw %>', '<%= addonDetails %>')"
                                            class="inline-flex items-center gap-1.5 rounded-xl bg-slate-800 px-3.5 py-2 text-[11px] font-black uppercase text-white shadow-sm hover:bg-slate-700 transition-all active:scale-95">
                                        <i class="fa-solid fa-download text-[10px]"></i>
                                        <span>Download Receipt</span>
                                    </button>
                                <% } else if (isDateReached) { %>
                                    <!-- Date Reached -> Enable Settlement -->
                                    <button type="button" 
                                            onclick="settleAndDownloadPDF(this, '<%= rs.getInt("id") %>', '<%= rs.getString("appointment_number") %>', '<%= escapedPatientName %>', '<%= escapedTreatmentType %>', <%= baseFee %>, <%= addonFee %>, <%= totalFeeWithTax %>, '<%= appDateRaw %>', '<%= addonDetails %>')"
                                            class="settle-btn inline-flex items-center gap-1.5 rounded-xl bg-emerald-600 px-4 py-2 text-[11px] font-black tracking-wide uppercase text-white shadow-sm hover:bg-emerald-500 transition-all active:scale-95">
                                        <i class="fa-solid fa-file-pdf text-[10px]"></i>
                                        <span>SETTLE BILL</span>
                                    </button>
                                <% } else { %>
                                    <!-- Date NOT Reached -> Show Locked Button -->
                                    <button type="button" 
                                            disabled 
                                            title="Billing unlocks on appointment date (<%= appDateRaw %>)"
                                            class="inline-flex items-center gap-1.5 rounded-xl bg-slate-200/80 border border-slate-300 px-4 py-2 text-[11px] font-bold text-slate-400 cursor-not-allowed shadow-none">
                                        <i class="fa-solid fa-lock text-[10px] text-slate-400"></i>
                                        <span>LOCKED (FUTURE DATE)</span>
                                    </button>
                                <% } %>
                            </td>
                        </tr>
                    <%
                            }
                            if (totalRecordCount == 0) {
                    %>
                        <tr id="emptyRow">
                            <td colspan="6" class="px-6 py-16 text-center text-sm font-bold text-slate-400 bg-slate-50/30">
                                <div class="flex flex-col items-center justify-center gap-3">
                                    <div class="h-12 w-12 rounded-full bg-slate-100 flex items-center justify-center border border-slate-200 text-slate-400 shadow-inner">
                                        <i class="fa-solid fa-folder-open text-xl"></i>
                                    </div>
                                    <span class="tracking-wide text-xs uppercase font-black text-slate-400">No medical bills found on file.</span>
                                </div>
                            </td>
                        </tr>
                    <%
                            }
                            rs.close();
                            stmt.close();
                        } catch (Exception e) {
                    %>
                        <tr>
                            <td colspan="6" class="px-6 py-12 text-center text-xs font-bold text-rose-600 bg-rose-50/40">
                                <div class="flex flex-col items-center justify-center gap-2">
                                    <i class="fa-solid fa-triangle-exclamation text-xl animate-bounce"></i>
                                    <span>Error parsing ledger data arrays from database pool context. Verify configuration parameters.</span>
                                </div>
                            </td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
            
            <!-- Terminal Balance Info Footer -->
            <div class="p-4 bg-emerald-50/80 border-t border-emerald-200/60 flex gap-3 items-start mt-auto backdrop-blur-sm">
                <i class="fa-solid fa-shield-halved text-emerald-600 text-sm mt-0.5"></i>
                <p class="text-[11px] font-semibold leading-relaxed text-emerald-900">
                    <strong class="font-bold">Scheduled Lock Active:</strong> Billing settlements are locked for future dates and only unlock on or after the scheduled treatment date.
                </p>
            </div>
        </div>

    </div>
</div>

<script>
    const { jsPDF } = window.jspdf;

    async function settleAndDownloadPDF(button, appointmentId, appNumber, patientName, treatmentType, baseFee, addonFee, totalWithTax, appDate, addonDetails) {
        button.disabled = true;
        const originalHtml = button.innerHTML;
        button.innerHTML = `<i class="fa-solid fa-circle-notch animate-spin text-[10px]"></i> <span>Processing...</span>`;

        try {
            const response = await fetch('${pageContext.request.contextPath}/BillingServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams({
                    'appointmentId': appointmentId
                })
            });

            if (!response.ok) {
                throw new Error('Database settlement update failed.');
            }

            // Generate receipt PDF
            generateInvoicePDF(appNumber, patientName, treatmentType, baseFee, addonFee, totalWithTax, appDate, addonDetails);

            // Update row UI in-place without removing it
            const row = button.closest('tr');
            row.setAttribute('data-status', 'PAID');
            
            // Update Status Badge
            const statusBadge = row.querySelector('.status-badge');
            if (statusBadge) {
                statusBadge.className = 'status-badge inline-flex items-center gap-1 w-max px-2 py-0.5 rounded-full text-[9px] font-black uppercase tracking-wider bg-emerald-100 text-emerald-800';
                statusBadge.innerHTML = `<i class="fa-solid fa-circle-check text-emerald-600"></i><span>PAID</span>`;
            }

            // Replace Settle Button with Download Receipt Button
            const actionTd = button.parentElement;
            actionTd.innerHTML = `
                <button type="button" 
                        onclick="generateInvoicePDF('${appNumber}', '${patientName}', '${treatmentType}', ${baseFee}, ${addonFee}, ${totalWithTax}, '${appDate}', '${addonDetails}')"
                        class="inline-flex items-center gap-1.5 rounded-xl bg-slate-800 px-3.5 py-2 text-[11px] font-black uppercase text-white shadow-sm hover:bg-slate-700 transition-all active:scale-95">
                    <i class="fa-solid fa-download text-[10px]"></i>
                    <span>Download Receipt</span>
                </button>
            `;

            decrementPendingCounter();

        } catch (error) {
            alert("Settlement Error: " + error.message);
            button.disabled = false;
            button.innerHTML = originalHtml;
        }
    }

    function generateInvoicePDF(appNumber, patientName, treatmentType, baseFee, addonFee, totalWithTax, appDate, addonDetails) {
        const doc = new jsPDF();
        const subtotal = baseFee + addonFee;
        const taxAmount = totalWithTax - subtotal;

        doc.setFillColor(16, 185, 129);
        doc.rect(0, 0, 210, 30, 'F');

        doc.setTextColor(255, 255, 255);
        doc.setFont("helvetica", "bold");
        doc.setFontSize(18);
        doc.text("SUNRISE DENTAL CLINIC", 14, 18);
        doc.setFontSize(10);
        doc.text("OFFICIAL SETTLEMENT RECEIPT", 14, 25);

        doc.setTextColor(50, 50, 50);
        doc.setFontSize(10);
        doc.setFont("helvetica", "normal");
        
        doc.text("Receipt Date: " + new Date().toLocaleDateString(), 140, 40);
        doc.text("App Ref No: " + appNumber, 140, 46);
        doc.text("Appointment Date: " + appDate, 140, 52);

        doc.setFont("helvetica", "bold");
        doc.text("PATIENT INFORMATION", 14, 40);
        doc.setFont("helvetica", "normal");
        doc.text("Patient Name: " + patientName, 14, 46);
        doc.text("Primary Treatment: " + treatmentType, 14, 52);

        doc.setFillColor(241, 245, 249);
        doc.rect(14, 65, 182, 10, 'F');
        doc.setFont("helvetica", "bold");
        doc.text("Description", 18, 71);
        doc.text("Amount (LKR)", 160, 71);

        let currentY = 83;

        doc.setFont("helvetica", "normal");
        doc.text(treatmentType + " - Base Consultation", 18, currentY);
        doc.text(baseFee.toFixed(2), 160, currentY);
        currentY += 8;

        if (addonDetails && addonDetails.trim() !== "") {
            const addonsArr = addonDetails.split("||");
            addonsArr.forEach(addon => {
                doc.text("+ " + addon, 18, currentY);
                currentY += 8;
            });
        }

        doc.text("Tax / Service Charge (20%)", 18, currentY);
        doc.text(taxAmount.toFixed(2), 160, currentY);
        currentY += 7;

        doc.setLineWidth(0.5);
        doc.line(14, currentY, 196, currentY);
        currentY += 10;

        doc.setFont("helvetica", "bold");
        doc.setFontSize(12);
        doc.text("TOTAL PAID:", 18, currentY);
        doc.text(totalWithTax.toFixed(2) + " LKR", 160, currentY);

        doc.setFontSize(9);
        doc.setFont("helvetica", "italic");
        doc.setTextColor(120, 120, 120);
        doc.text("Thank you for choosing Sunrise Dental Clinic. Wish you a healthy smile!", 14, currentY + 20);

        doc.save("Invoice_" + appNumber + "_" + patientName.replace(/\s+/g, '_') + ".pdf");
    }

    function decrementPendingCounter() {
        const counterEl = document.getElementById('pendingCounter');
        let count = parseInt(counterEl.textContent, 10);
        if (count > 0) {
            counterEl.textContent = count - 1;
        }
    }

    function filterBillingTable() {
        const query = document.getElementById('billingSearch').value.toLowerCase();
        const rows = document.querySelectorAll('.billing-row');
        
        rows.forEach(row => {
            const name = row.querySelector('.searchable-patient').textContent.toLowerCase();
            const appNum = row.querySelector('.inline-flex').textContent.toLowerCase();
            
            if(name.includes(query) || appNum.includes(query)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    document.addEventListener("DOMContentLoaded", () => {
        document.getElementById('pendingCounter').textContent = "<%= pendingRecordCount %>";
    });
</script>

<jsp:include page="../components/footer.jsp" />