<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.config.DatabaseConnection, java.sql.*" %>
<%
    if(session.getAttribute("user") == null || !"RECEPTIONIST".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=Access Denied: Receptionist Session Required");
        return;
    }

    String appIdParam = request.getParameter("id");
    if(appIdParam == null || appIdParam.trim().isEmpty()) {
        response.sendRedirect("view-appointments.jsp?error=Invalid Appointment Selected");
        return;
    }

    int appointmentId = Integer.parseInt(appIdParam);
    
    String appNum = "", patientName = "", dentistName = "", baseTreatment = "", date = "", time = "", status = "";
    double baseFee = 0.0, totalAddons = 0.0;
    
    Connection conn = DatabaseConnection.getInstance().getConnection();
    
    // Fetch Appointment and Patient details
    String appSql = "SELECT a.*, p.name AS patient_name FROM appointments a JOIN patients p ON a.patient_id = p.id WHERE a.id = ?";
    PreparedStatement psApp = conn.prepareStatement(appSql);
    psApp.setInt(1, appointmentId);
    ResultSet rsApp = psApp.executeQuery();
    
    if(rsApp.next()) {
        appNum = rsApp.getString("appointment_number");
        patientName = rsApp.getString("patient_name");
        dentistName = rsApp.getString("dentist_name");
        baseTreatment = rsApp.getString("treatment_type");
        baseFee = rsApp.getDouble("consultation_fee");
        date = rsApp.getString("appointment_date");
        time = rsApp.getString("appointment_time");
        status = rsApp.getString("payment_status");
    } else {
        response.sendRedirect("view-appointments.jsp?error=Appointment Not Found");
        return;
    }
    rsApp.close();
    psApp.close();

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<jsp:include page="../components/header.jsp" />

<style>
    .glass-hud {
        background: rgba(224, 242, 254, 0.75);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.5);
    }
    .glass-card {
        background: rgba(255, 255, 255, 0.90);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.6);
    }
    @keyframes slideInRight {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    .animate-slide-in {
        animation: slideInRight 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards;
    }
</style>

<!-- Floating Toast Container -->
<div id="toastContainer" class="fixed top-5 right-5 z-50 flex flex-col gap-3 max-w-sm"></div>

<div class="relative min-h-[88vh] rounded-3xl overflow-hidden p-4 sm:p-6 lg:p-10 border border-slate-200/60 shadow-xl bg-cover bg-center"
     style="background-image: url('https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=1920&q=80');">
    
    <div class="absolute inset-0 z-0 bg-gradient-to-tr from-slate-950/85 via-slate-900/40 to-blue-950/20"></div>

    <div class="relative z-10 max-w-4xl mx-auto space-y-6">

        <!-- Header -->
        <div class="glass-hud rounded-2xl p-5 shadow-lg flex items-center justify-between">
            <div>
                <h1 class="text-xl font-black text-slate-900 uppercase">Manage Treatment Add-ons</h1>
                <p class="text-xs font-medium text-slate-500">Ref <%= appNum %> — Patient: <%= patientName %></p>
            </div>
            <a href="view-appointments.jsp" class="rounded-xl border border-slate-200 bg-white/90 px-4 py-2 text-xs font-bold text-slate-700 hover:bg-slate-50 transition-all">
                <i class="fa-solid fa-arrow-left"></i> Back to Directory
            </a>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            
            <!-- Left: Add Extra Procedure Form with Dynamic Dropdown -->
            <div class="glass-card rounded-2xl p-6 shadow-xl space-y-4">
                <h2 class="text-xs font-black uppercase text-orange-600 tracking-wider flex items-center gap-1.5">
                    <i class="fa-solid fa-circle-plus"></i> Add Extra Procedure
                </h2>
                
                <form id="addAddonForm" action="${pageContext.request.contextPath}/AddonServlet" method="post" onsubmit="handleFormSubmit(this)" class="space-y-4">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="appointmentId" value="<%= appointmentId %>">

                    <!-- Dynamic Treatment Dropdown -->
                    <div>
                        <label class="block text-[10px] font-black uppercase text-slate-400 mb-1">Select Procedure</label>
                        <select id="addonSelect" name="addonName" onchange="updateFeeFromSelection()" required 
                                class="w-full rounded-xl border border-slate-200 bg-slate-50/80 p-2.5 text-xs font-bold text-slate-800 focus:outline-none focus:border-sky-500 focus:bg-white transition-all">
                            <option value="" data-price="0.00">-- Choose Treatment --</option>
                            <%
                                try {
                                    String treatSql = "SELECT treatment_name, base_price FROM treatments ORDER BY treatment_name ASC";
                                    Statement stmtTreat = conn.createStatement();
                                    ResultSet rsTreat = stmtTreat.executeQuery(treatSql);
                                    
                                    while(rsTreat.next()) {
                                        String tName = rsTreat.getString("treatment_name");
                                        double tPrice = rsTreat.getDouble("base_price");
                            %>
                                <option value="<%= tName %>" data-price="<%= String.format("%.2f", tPrice) %>">
                                    <%= tName %>
                                </option>
                            <%
                                    }
                                    rsTreat.close();
                                    stmtTreat.close();
                                } catch (Exception e) {
                                    out.println("<option value=''>Error Loading Treatments</option>");
                                }
                            %>
                        </select>
                    </div>

                    <!-- Auto-populated Fee Field -->
                    <div>
                        <label class="block text-[10px] font-black uppercase text-slate-400 mb-1">Fee (LKR)</label>
                        <input type="number" step="0.01" id="addonPrice" name="addonPrice" placeholder="0.00" required 
                               class="w-full rounded-xl border border-slate-200 bg-slate-50/80 p-2.5 text-xs font-bold text-slate-800 focus:outline-none focus:border-sky-500 focus:bg-white transition-all">
                    </div>

                    <button type="submit" id="submitBtn" class="w-full rounded-xl bg-orange-600 py-3 text-xs font-black uppercase text-white shadow-md hover:bg-orange-500 active:scale-95 transition-all flex items-center justify-center gap-2">
                        <i class="fa-solid fa-plus"></i>
                        <span>Add To Bill</span>
                    </button>
                </form>
            </div>

            <!-- Right: Itemized Bill Breakdown -->
            <div class="md:col-span-2 glass-card rounded-2xl p-6 shadow-xl flex flex-col justify-between">
                <div>
                    <h2 class="text-xs font-black uppercase text-slate-500 tracking-wider mb-4 flex items-center gap-1.5">
                        <i class="fa-solid fa-file-invoice-dollar"></i> Itemized Bill Statement
                    </h2>

                    <!-- Base Consultation Item -->
                    <div class="divide-y divide-slate-100">
                        <div class="py-3 flex justify-between items-center">
                            <div>
                                <span class="text-xs font-bold text-slate-900 block"><%= baseTreatment %> (Base)</span>
                                <span class="text-[10px] text-slate-400">Doctor: <%= dentistName %></span>
                            </div>
                            <span class="font-mono text-xs font-black text-slate-800"><%= String.format("%,.2f LKR", baseFee) %></span>
                        </div>

                        <!-- Render Extra Add-ons -->
                        <%
                            String addonSql = "SELECT * FROM appointment_addons WHERE appointment_id = ? ORDER BY id ASC";
                            PreparedStatement psAddon = conn.prepareStatement(addonSql);
                            psAddon.setInt(1, appointmentId);
                            ResultSet rsAddon = psAddon.executeQuery();

                            while(rsAddon.next()) {
                                int addonId = rsAddon.getInt("id");
                                String aName = rsAddon.getString("addon_name");
                                double aPrice = rsAddon.getDouble("addon_price");
                                totalAddons += aPrice;
                                String escapedName = aName.replace("'", "\\'");
                        %>
                            <div class="py-3 flex justify-between items-center group">
                                <div>
                                    <span class="text-xs font-bold text-slate-800 block"><%= aName %></span>
                                    <span class="text-[9px] font-bold text-orange-600 uppercase">Extra Treatment</span>
                                </div>
                                <div class="flex items-center gap-3">
                                    <span class="font-mono text-xs font-black text-slate-800"><%= String.format("%,.2f LKR", aPrice) %></span>
                                    
                                    <button type="button" 
                                            onclick="openDeleteModal('<%= addonId %>', '<%= escapedName %>', '<%= String.format("%.2f", aPrice) %>')"
                                            class="text-slate-400 hover:text-rose-600 text-xs p-1 transition-colors"
                                            title="Remove item">
                                        <i class="fa-solid fa-trash-can"></i>
                                    </button>
                                </div>
                            </div>
                        <%
                            }
                            rsAddon.close();
                            psAddon.close();

                            double grandTotal = (baseFee + totalAddons) * 1.20; // Inclusive of 20% Tax
                        %>
                    </div>
                </div>

                <!-- Grand Total Footer -->
                <div class="mt-6 border-t border-slate-200 pt-4 flex justify-between items-center bg-slate-50/80 p-4 rounded-xl border border-slate-100">
                    <div>
                        <span class="text-[10px] font-black uppercase text-slate-400 block">Grand Total (Inc. 20% Tax)</span>
                        <span class="text-xs font-bold text-slate-500">Subtotal: <%= String.format("%,.2f LKR", baseFee + totalAddons) %></span>
                    </div>
                    <span class="text-lg font-mono font-black text-emerald-600"><%= String.format("%,.2f LKR", grandTotal) %></span>
                </div>
            </div>

        </div>

    </div>
</div>

<!-- Modal: Delete Confirmation Popup -->
<div id="deleteModal" class="fixed inset-0 z-50 hidden flex items-center justify-center bg-slate-950/60 backdrop-blur-sm p-4 transition-all">
    <div class="bg-white rounded-2xl max-w-sm w-full p-6 shadow-2xl space-y-4 border border-slate-100 transform transition-all scale-95" id="deleteModalCard">
        <div class="flex items-center gap-3">
            <div class="h-10 w-10 rounded-full bg-rose-100 text-rose-600 flex items-center justify-center flex-shrink-0">
                <i class="fa-solid fa-triangle-exclamation text-lg"></i>
            </div>
            <div>
                <h3 class="text-sm font-black text-slate-900 uppercase">Remove Treatment?</h3>
                <p class="text-xs text-slate-500">This action will update the patient's total bill balance.</p>
            </div>
        </div>

        <div class="bg-slate-50 p-3 rounded-xl border border-slate-200/60 text-xs font-medium text-slate-700">
            Removing: <strong id="deleteItemName" class="text-slate-900"></strong> 
            (<span id="deleteItemPrice" class="font-mono text-rose-600 font-bold"></span> LKR)
        </div>

        <form action="${pageContext.request.contextPath}/AddonServlet" method="post" class="flex gap-2">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="appointmentId" value="<%= appointmentId %>">
            <input type="hidden" name="addonId" id="modalAddonId" value="">

            <button type="button" onclick="closeDeleteModal()" 
                    class="flex-1 rounded-xl border border-slate-200 py-2.5 text-xs font-bold text-slate-600 hover:bg-slate-50 transition-all">
                Cancel
            </button>
            <button type="submit" 
                    class="flex-1 rounded-xl bg-rose-600 py-2.5 text-xs font-black uppercase text-white shadow-md hover:bg-rose-500 transition-all">
                Confirm Delete
            </button>
        </form>
    </div>
</div>

<script>
    // Automatically update the price input box when a treatment is selected
    function updateFeeFromSelection() {
        const select = document.getElementById('addonSelect');
        const priceInput = document.getElementById('addonPrice');
        
        // Get the data-price attribute of the selected option
        const selectedOption = select.options[select.selectedIndex];
        const price = selectedOption.getAttribute('data-price');
        
        if (price) {
            priceInput.value = price;
        } else {
            priceInput.value = '';
        }
    }

    function showToast(message, type = 'success') {
        const container = document.getElementById('toastContainer');
        const toast = document.createElement('div');
        
        const bgColor = type === 'success' ? 'bg-emerald-600' : 'bg-rose-600';
        const icon = type === 'success' ? 'fa-circle-check' : 'fa-circle-exclamation';

        toast.className = `${bgColor} text-white px-4 py-3 rounded-xl shadow-xl font-medium text-xs flex items-center justify-between gap-3 animate-slide-in min-w-[280px]`;
        toast.innerHTML = `
            <div class="flex items-center gap-2">
                <i class="fa-solid ${icon} text-sm"></i>
                <span>${message}</span>
            </div>
            <button onclick="this.parentElement.remove()" class="text-white/80 hover:text-white"><i class="fa-solid fa-xmark"></i></button>
        `;

        container.appendChild(toast);

        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transition = 'all 0.3s ease';
            setTimeout(() => toast.remove(), 300);
        }, 4000);
    }

    function openDeleteModal(addonId, itemName, itemPrice) {
        document.getElementById('modalAddonId').value = addonId;
        document.getElementById('deleteItemName').textContent = itemName;
        document.getElementById('deleteItemPrice').textContent = itemPrice;
        
        const modal = document.getElementById('deleteModal');
        const card = document.getElementById('deleteModalCard');
        modal.classList.remove('hidden');
        setTimeout(() => {
            card.classList.remove('scale-95');
            card.classList.add('scale-100');
        }, 10);
    }

    function closeDeleteModal() {
        const modal = document.getElementById('deleteModal');
        const card = document.getElementById('deleteModalCard');
        card.classList.remove('scale-100');
        card.classList.add('scale-95');
        setTimeout(() => {
            modal.classList.add('hidden');
        }, 150);
    }

    function handleFormSubmit(form) {
        const btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = `<i class="fa-solid fa-circle-notch animate-spin"></i> Processing...`;
    }

    document.addEventListener('DOMContentLoaded', () => {
        <% if (msg != null && !msg.trim().isEmpty()) { %>
            showToast("<%= msg.replace("\"", "\\\"") %>", 'success');
        <% } %>
        
        <% if (error != null && !error.trim().isEmpty()) { %>
            showToast("<%= error.replace("\"", "\\\"") %>", 'error');
        <% } %>
    });
</script>

<jsp:include page="../components/footer.jsp" />