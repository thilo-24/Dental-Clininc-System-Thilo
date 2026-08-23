<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.config.DatabaseConnection, java.sql.*" %>
<%
    if(session.getAttribute("user") == null || !"RECEPTIONIST".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=Access Denied: Receptionist Session Required");
        return;
    }
%>
<jsp:include page="../components/header.jsp" />

<style>
    .glass-hud {
        background: rgba(224, 242, 254, 0.75);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.5);
        box-shadow: 0 8px 32px 0 rgba(15, 23, 42, 0.08);
    }
    .glass-card {
        background: rgba(255, 255, 255, 0.85);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.6);
    }
</style>

<div class="relative min-h-[88vh] rounded-3xl overflow-hidden p-4 sm:p-6 lg:p-10 border border-slate-200/60 shadow-xl bg-cover bg-center"
     style="background-image: url('https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=1920&q=80');">
    
    <div class="absolute inset-0 z-0 bg-gradient-to-tr from-slate-950/85 via-slate-900/40 to-blue-950/20"></div>

    <div class="relative z-10 max-w-6xl mx-auto space-y-6">

        <!-- Header Bar -->
        <div class="glass-hud rounded-2xl border border-white/40 p-5 sm:p-6 shadow-lg">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                <div>
                    <div class="flex items-center gap-2">
                        <span class="inline-flex h-7 w-7 items-center justify-center rounded-lg bg-sky-600 text-white shadow-sm">
                            <i class="fa-solid fa-calendar-check text-xs"></i>
                        </span>
                        <h1 class="text-xl font-black tracking-tight text-slate-900 uppercase sm:text-2xl">Booked Appointments Directory</h1>
                    </div>
                    <p class="mt-1 text-xs sm:text-sm font-medium text-slate-500">Overview of scheduled consultations, assigned doctors, and additional treatments.</p>
                </div>
                
                <a href="dashboard.jsp" class="inline-flex items-center gap-2 self-start md:self-center rounded-xl border border-slate-200 bg-white/90 px-4 py-2 text-xs font-bold text-slate-700 shadow-sm transition-all hover:bg-slate-50">
                    <i class="fa-solid fa-arrow-left-long text-slate-400"></i>
                    <span>Dashboard View</span>
                </a>
            </div>
        </div>

        <!-- Search Bar -->
        <div class="glass-hud flex flex-col sm:flex-row items-center justify-between gap-4 rounded-2xl border border-white/40 p-4 shadow-md">
             <div class="relative w-full sm:max-w-md">
                <input type="text" id="appointmentSearch" onkeyup="filterAppointments()" 
                       placeholder="Filter by patient name, id, phone, address..." 
                       class="w-full rounded-xl border border-slate-200/80 bg-slate-50/60 py-2.5 pl-4 pr-10 text-xs font-bold text-slate-700 placeholder-slate-400 focus:border-sky-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-sky-500 transition-all shadow-inner" />
                       
                <span class="absolute inset-y-0 right-0 flex items-center pr-3.5 pointer-events-none text-slate-400">
                    <i class="fa-solid fa-magnifying-glass text-xs"></i>
                </span>
            </div>
            
            <a href="book-appointment.jsp" class="inline-flex items-center gap-2 rounded-xl bg-orange-600 px-4 py-2.5 text-xs font-black uppercase text-white shadow-md hover:bg-orange-500 transition-all">
                <i class="fa-solid fa-plus text-xs"></i>
                <span>New Appointment</span>
            </a>
        </div>

        <!-- Data Grid -->
        <div class="glass-card overflow-hidden rounded-2xl border border-white/50 shadow-2xl flex flex-col justify-between min-h-[450px]">
            <div class="overflow-x-auto">
                <table class="w-full border-collapse text-left text-xs text-slate-600">
                    <thead>
                        <tr class="border-b border-slate-200 bg-slate-100/60 font-black uppercase tracking-wider text-slate-400 text-[10px]">
                            <th scope="col" class="px-5 py-4">App Ref</th>
                            <th scope="col" class="px-5 py-4">Patient Information</th>
                            <th scope="col" class="px-5 py-4">Assigned Doctor</th>
                            <th scope="col" class="px-5 py-4">Treatments & Add-ons</th>
                            <th scope="col" class="px-5 py-4">Total Fee (Inc. Tax)</th>
                            <th scope="col" class="px-5 py-4">Date & Time</th>
                            <th scope="col" class="px-5 py-4 text-center">Status</th>
                            <th scope="col" class="px-5 py-4 text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="appointmentTableBody" class="divide-y divide-slate-100 font-medium">
                    <%
                        int totalRecords = 0;
                        try {
                            Connection conn = DatabaseConnection.getInstance().getConnection();
                            // LEFT JOIN appointment_addons to sum extra treatments dynamically
                            String sql = "SELECT a.id, a.appointment_number, a.patient_id, p.name AS patient_name, " +
                                         "p.contact_number AS patient_phone, p.address AS patient_address, " +
                                         "a.dentist_name, a.treatment_type, a.consultation_fee, a.appointment_date, " +
                                         "a.appointment_time, a.payment_status, " +
                                         "COALESCE(SUM(ad.addon_price), 0) AS total_addons, " +
                                         "GROUP_CONCAT(ad.addon_name SEPARATOR ', ') AS addon_list " +
                                         "FROM appointments a " +
                                         "JOIN patients p ON a.patient_id = p.id " +
                                         "LEFT JOIN appointment_addons ad ON a.id = ad.appointment_id " +
                                         "GROUP BY a.id " +
                                         "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
                            
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery(sql);
                            
                            while(rs.next()) {
                                totalRecords++;
                                int appId = rs.getInt("id");
                                double baseFee = rs.getDouble("consultation_fee");
                                double addonFee = rs.getDouble("total_addons");
                                double subtotal = baseFee + addonFee;
                                double totalFeeWithTax = subtotal * 1.20;
                                String status = rs.getString("payment_status");
                                String address = rs.getString("patient_address");
                                String addons = rs.getString("addon_list");
                    %>
                        <tr class="app-row transition-all duration-200 hover:bg-sky-50/40">
                            <!-- Ref Code -->
                            <td class="whitespace-nowrap px-5 py-4 font-bold text-slate-900">
                                <span class="inline-flex items-center gap-1 rounded-lg bg-slate-100 border border-slate-300/60 px-2 py-1 text-[11px] font-mono font-bold text-slate-700 shadow-inner">
                                    <%= rs.getString("appointment_number") %>
                                </span>
                            </td>
                            
                            <!-- Patient Info -->
                            <td class="px-5 py-4">
                                <div class="flex flex-col space-y-0.5">
                                    <span class="text-xs font-black text-slate-900 searchable-data"><%= rs.getString("patient_name") %></span>
                                    <span class="text-[10px] text-slate-500 font-semibold">
                                        ID: #<%= rs.getInt("patient_id") %> | Ph: <%= rs.getString("patient_phone") != null ? rs.getString("patient_phone") : "N/A" %>
                                    </span>
                                    <span class="text-[10px] text-slate-400 font-medium flex items-center gap-1">
                                        <i class="fa-solid fa-location-dot text-[9px]"></i>
                                        <%= address != null && !address.trim().isEmpty() ? address : "No address recorded" %>
                                    </span>
                                </div>
                            </td>
                            
                            <!-- Assigned Doctor -->
                            <td class="whitespace-nowrap px-5 py-4">
                                <span class="font-bold text-slate-800 searchable-data flex items-center gap-1.5">
                                    <i class="fa-solid fa-user-doctor text-sky-600 text-xs"></i>
                                    <%= rs.getString("dentist_name") %>
                                </span>
                            </td>
                            
                            <!-- Base + Extra Treatments -->
                            <td class="px-5 py-4">
                                <div class="flex flex-col gap-1">
                                    <span class="inline-flex items-center gap-1 rounded-md bg-slate-100 px-2 py-0.5 text-[10px] font-bold text-slate-700 border border-slate-200">
                                        <i class="fa-solid fa-tooth text-orange-500"></i>
                                        <%= rs.getString("treatment_type") %>
                                    </span>
                                    <% if(addons != null && !addons.isEmpty()) { %>
                                        <span class="text-[10px] font-semibold text-orange-600 flex items-center gap-1">
                                            <i class="fa-solid fa-plus-circle"></i> <%= addons %>
                                        </span>
                                    <% } %>
                                </div>
                            </td>
                            
                            <!-- Calculated Fee -->
                            <td class="whitespace-nowrap px-5 py-4 font-mono text-xs font-black text-slate-900">
                                <div class="flex flex-col">
                                    <span class="text-emerald-700 font-extrabold"><%= String.format("%,.2f LKR", totalFeeWithTax) %></span>
                                    <span class="text-[9px] text-slate-400 font-sans font-normal">Base: <%= String.format("%,.2f", baseFee) %> | Extra: <%= String.format("%,.2f", addonFee) %></span>
                                </div>
                            </td>
                            
                            <!-- Date & Time -->
                            <td class="whitespace-nowrap px-5 py-4 text-slate-500 text-[11px]">
                                <div class="flex flex-col gap-0.5">
                                    <span class="font-bold text-slate-800 flex items-center gap-1">
                                        <i class="fa-regular fa-calendar text-slate-400"></i><%= rs.getDate("appointment_date") %>
                                    </span>
                                    <span class="font-semibold text-slate-500 flex items-center gap-1">
                                        <i class="fa-regular fa-clock text-slate-400"></i><%= rs.getTime("appointment_time") %>
                                    </span>
                                </div>
                            </td>
                            
                            <!-- Status -->
                            <td class="whitespace-nowrap px-5 py-4 text-center">
                                <% if("PAID".equalsIgnoreCase(status)) { %>
                                    <span class="inline-flex items-center gap-1 rounded-full bg-emerald-100 px-2.5 py-1 text-[10px] font-black uppercase text-emerald-800 border border-emerald-200">
                                        <i class="fa-solid fa-circle-check"></i> PAID
                                    </span>
                                <% } else { %>
                                    <span class="inline-flex items-center gap-1 rounded-full bg-rose-100 px-2.5 py-1 text-[10px] font-black uppercase text-rose-800 border border-rose-200">
                                        <i class="fa-solid fa-clock"></i> PENDING
                                    </span>
                                <% } %>
                            </td>

                            <!-- Edit Button Action -->
                            <td class="whitespace-nowrap px-5 py-4 text-center">
                                <a href="edit-appointment.jsp?id=<%= appId %>" 
                                   class="inline-flex items-center gap-1.5 rounded-lg border border-sky-200 bg-sky-50 px-3 py-1.5 text-[11px] font-black text-sky-700 hover:bg-sky-600 hover:text-white transition-all shadow-sm">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                    <span>Edit / Add-ons</span>
                                </a>
                            </td>
                        </tr>
                    <%
                            }
                            if (totalRecords == 0) {
                    %>
                        <tr>
                            <td colspan="8" class="px-6 py-16 text-center text-xs font-bold text-slate-400 bg-slate-50/30">
                                No booked appointments found in the system.
                            </td>
                        </tr>
                    <%
                            }
                            rs.close();
                            stmt.close();
                        } catch(Exception e) {
                    %>
                        <tr>
                            <td colspan="8" class="px-6 py-12 text-center text-xs font-bold text-rose-600 bg-rose-50/40">
                                Error fetching appointment records: <%= e.getMessage() %>
                            </td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

<script>
    function filterAppointments() {
        const query = document.getElementById('appointmentSearch').value.toLowerCase();
        const rows = document.querySelectorAll('.app-row');
        
        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(query) ? '' : 'none';
        });
    }
</script>

<jsp:include page="../components/footer.jsp" />