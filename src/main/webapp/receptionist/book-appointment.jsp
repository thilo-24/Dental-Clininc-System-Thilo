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
    .glass-schedule-hud {
        background: rgba(224, 242, 254, 0.75);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.5);
        box-shadow: 0 8px 32px 0 rgba(15, 23, 42, 0.08);
    }
    .glass-form-card {
        background: rgba(255, 255, 255, 0.85);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.6);
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    }
</style>

<div class="relative min-h-[88vh] rounded-3xl overflow-hidden p-4 sm:p-6 lg:p-10 border border-slate-200/60 shadow-xl bg-cover bg-center transition-all duration-700"
     style="background-image: url('https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=1920&q=80');">
    
    <div class="absolute inset-0 z-0 bg-gradient-to-tr from-slate-950/85 via-slate-900/40 to-orange-950/20"></div>

    <div class="relative z-10 max-w-xl mx-auto space-y-6">

        <div class="glass-schedule-hud rounded-2xl border border-white/40 p-5 shadow-lg shadow-slate-900/10">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div>
                    <div class="flex items-center gap-2">
                        <span class="inline-flex h-6 w-6 items-center justify-center rounded-md bg-orange-600 text-white shadow-sm shadow-orange-600/20">
                            <i class="fa-solid fa-calendar-plus text-[11px]"></i>
                        </span>
                        <h1 class="text-xl font-black tracking-tight text-slate-900 uppercase sm:text-2xl">Schedule Slot</h1>
                    </div>
                    <p class="mt-1 text-xs font-medium text-slate-500">Allocate new treatment sessions and reserve slots.</p>
                </div>
                
                <a href="dashboard.jsp" class="inline-flex items-center gap-2 self-start sm:self-center rounded-xl border border-slate-200 bg-white/90 px-4 py-2 text-xs font-bold text-slate-700 shadow-sm transition-all hover:bg-slate-50 hover:text-slate-900 active:scale-[0.98] backdrop-blur-sm">
                    <i class="fa-solid fa-arrow-left-long text-slate-400"></i>
                    <span>Dashboard View</span>
                </a>
            </div>
        </div>

        <div class="glass-form-card rounded-2xl border border-white/50 shadow-2xl overflow-hidden">
            <div class="h-1.5 bg-gradient-to-r from-orange-500 via-amber-500 to-yellow-500"></div>

            <div class="p-6 sm:p-8">
                <% if(request.getParameter("error") != null) { %>
                    <div id="errorToast" class="mb-6 flex items-center justify-between rounded-xl bg-rose-50/90 border border-rose-200 p-4 text-rose-800 shadow-sm transition-all duration-300 backdrop-blur-sm animate-fadeIn">
                        <div class="flex items-center gap-3">
                            <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-rose-600 text-white shrink-0 shadow-sm">
                                <i class="fa-solid fa-triangle-exclamation"></i>
                            </div>
                            <p class="text-xs font-black leading-tight tracking-wide"><%= request.getParameter("error") %></p>
                        </div>
                        <button onclick="dismissError()" type="button" class="rounded-lg p-1 text-rose-500 hover:bg-rose-200/50 transition-colors">
                            <i class="fa-solid fa-xmark text-sm"></i>
                        </button>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/AppointmentServlet" method="post" onsubmit="return validateAndLockForm(this)" class="space-y-5">
                    
                    <!-- Patient ID -->
                    <div class="group">
                        <div class="flex items-center justify-between mb-2">
                            <label class="block text-[10px] font-black tracking-wider text-slate-400 uppercase group-focus-within:text-orange-600 transition-colors">Validated Patient Reference ID <span class="text-rose-500">*</span></label>
                            <span id="patientIdError" class="hidden text-[10px] font-bold text-rose-600">Patient ID required</span>
                        </div>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400 z-10 group-focus-within:text-orange-500 transition-colors">
                                <i class="fa-solid fa-id-card text-xs"></i>
                            </span>
                            <input type="number" id="patientId" name="patientId" min="1" placeholder="e.g., 1042" 
                                   class="w-full rounded-xl border border-slate-200/80 bg-slate-50/60 py-2.5 pl-10 pr-4 text-xs font-bold text-slate-800 placeholder-slate-400 focus:border-orange-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-orange-500 transition-all shadow-inner" required>
                        </div>
                    </div>

                    <!-- Dental Surgeon Dropdown -->
                    <div class="group">
                        <label class="block text-[10px] font-black tracking-wider text-slate-400 mb-2 uppercase group-focus-within:text-orange-600 transition-colors">Assigned Dental Surgeon <span class="text-rose-500">*</span></label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400 z-10 group-focus-within:text-orange-500 transition-colors">
                                <i class="fa-solid fa-user-doctor text-xs"></i>
                            </span>
                            <select id="dentistSelect" name="dentistName" onchange="fetchBookedSlots()"
                                    class="relative w-full rounded-xl border border-slate-200/80 bg-slate-50/60 py-2.5 pl-10 pr-10 text-xs font-bold text-slate-700 focus:border-orange-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-orange-500 transition-all appearance-none cursor-pointer shadow-inner" required>
                                <option value="" disabled selected>-- Select Active Doctor --</option>
                                <%
                                    try {
                                        Connection conn = DatabaseConnection.getInstance().getConnection();
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery("SELECT doctor_name, specialization FROM doctors WHERE is_active = TRUE ORDER BY doctor_name ASC");
                                        while(rs.next()) {
                                            String docName = rs.getString("doctor_name");
                                            String spec = rs.getString("specialization");
                                            String specLabel = (spec != null && !spec.trim().isEmpty()) ? " (" + spec + ")" : "";
                                %>
                                    <option value="<%= docName %>"><%= docName %><%= specLabel %></option>
                                <%
                                        }
                                        rs.close();
                                        stmt.close();
                                    } catch (Exception e) {
                                %>
                                    <option value="">Error compiling doctor registry list...</option>
                                <%
                                    }
                                %>
                            </select>
                            <span class="absolute inset-y-0 right-0 flex items-center pr-3.5 pointer-events-none text-slate-400">
                                <i class="fa-solid fa-chevron-down text-[10px]"></i>
                            </span>
                        </div>
                    </div>

                    <!-- Treatment Classification Dropdown -->
                    <div class="group">
                        <label class="block text-[10px] font-black tracking-wider text-slate-400 mb-2 uppercase group-focus-within:text-orange-600 transition-colors">Treatment Classification <span class="text-rose-500">*</span></label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400 z-10 group-focus-within:text-orange-500 transition-colors">
                                <i class="fa-solid fa-tooth text-xs"></i>
                            </span>
                            <select name="treatmentType" 
                                    class="relative w-full rounded-xl border border-slate-200/80 bg-slate-50/60 py-2.5 pl-10 pr-10 text-xs font-bold text-slate-700 focus:border-orange-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-orange-500 transition-all appearance-none cursor-pointer shadow-inner" required>
                                <option value="" disabled selected>-- Select Treatment --</option>
                                <%
                                    try {
                                        Connection conn = DatabaseConnection.getInstance().getConnection();
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery("SELECT treatment_name, base_price FROM treatments ORDER BY treatment_name ASC");
                                        while(rs.next()) {
                                            String name = rs.getString("treatment_name");
                                            double price = rs.getDouble("base_price");
                                %>
                                    <option value="<%= name %>"><%= name %> (Base: <%= String.format("%,.2f", price) %> LKR)</option>
                                <%
                                        }
                                        rs.close(); 
                                        stmt.close();
                                    } catch (Exception e) {
                                %>
                                    <option value="">Error compiling dynamic data matrix...</option>
                                <%
                                    }
                                %>
                            </select>
                            <span class="absolute inset-y-0 right-0 flex items-center pr-3.5 pointer-events-none text-slate-400">
                                <i class="fa-solid fa-chevron-down text-[10px]"></i>
                            </span>
                        </div>
                    </div>

                    <!-- Target Date Input -->
                    <div class="group">
                        <label class="block text-[10px] font-black tracking-wider text-slate-400 mb-2 uppercase group-focus-within:text-orange-600 transition-colors">Target Date <span class="text-rose-500">*</span></label>
                        <input type="date" id="appointmentDate" name="appointmentDate" onchange="fetchBookedSlots()"
                               class="w-full rounded-xl border border-slate-200/80 bg-slate-50/60 p-2.5 text-xs font-bold text-slate-800 focus:border-orange-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-orange-500 transition-all shadow-inner" required>
                    </div>

                    <!-- Hidden Input for Form Submission -->
                    <input type="hidden" id="selectedAppointmentTime" name="appointmentTime" required>

                    <!-- Interactive 5 Daily Slot Matrix -->
                    <div>
                        <div class="flex items-center justify-between mb-2">
                            <label class="block text-[10px] font-black tracking-wider text-slate-400 uppercase">Daily Available Time Slots (5 Max) <span class="text-rose-500">*</span></label>
                            <span id="slotError" class="hidden text-[10px] font-bold text-rose-600">Select a time slot</span>
                        </div>
                        <div id="slotGrid" class="grid grid-cols-2 sm:grid-cols-3 gap-2 p-3 bg-slate-50/70 border border-slate-200/80 rounded-xl shadow-inner">
                            <div class="col-span-full text-center py-4 text-slate-400 text-xs font-medium">
                                <i class="fa-solid fa-clock mb-1 text-base block text-slate-300"></i>
                                Select a doctor and target date to view daily slots.
                            </div>
                        </div>
                    </div>

                    <!-- Submission Button -->
                    <div class="pt-4">
                        <button type="submit" id="submitBtn" 
                                class="w-full inline-flex items-center justify-center gap-2 rounded-xl bg-orange-600 px-5 py-3.5 text-xs font-black tracking-wide uppercase text-white shadow-md shadow-orange-600/10 transition-all hover:bg-orange-500 hover:shadow-lg active:scale-[0.98] focus:outline-none focus:ring-2 focus:ring-orange-500 focus:ring-offset-2">
                            <i class="fa-solid fa-calendar-plus text-sm"></i>
                            <span>Commit Booking Allocation</span>
                        </button>
                    </div>
                    
                </form>
            </div>
        </div>

    </div>
</div>

<script>
    // 5 Fixed Daily Time Slots
    const FIXED_SLOTS = [
        { raw: "09:00", label: "09:00 AM" },
        { raw: "11:00", label: "11:00 AM" },
        { raw: "14:00", label: "02:00 PM" },
        { raw: "16:00", label: "04:00 PM" },
        { raw: "18:00", label: "06:00 PM" },
        { raw: "20:00", label: "08:00 PM" }
    ];

    function dismissError() {
        const errorToast = document.getElementById('errorToast');
        if(errorToast) {
            errorToast.style.opacity = '0';
            setTimeout(() => errorToast.remove(), 300);
        }
    }

    document.addEventListener("DOMContentLoaded", () => {
        // Automatically set date picker minimum to today
        const dateInput = document.getElementById('appointmentDate');
        if(dateInput && !dateInput.value) {
            const today = new Date().toISOString().split('T')[0];
            dateInput.min = today;
            dateInput.value = today; // Pre-fill today's date for faster UX
        }
        
        // Initial render: display all 5 slots directly on page load
        fetchBookedSlots();
    });

    function fetchBookedSlots() {
        const dentistSelect = document.getElementById('dentistSelect');
        const dateInput = document.getElementById('appointmentDate');
        const dentist = dentistSelect ? dentistSelect.value : "";
        const date = dateInput ? dateInput.value : "";
        const hiddenTime = document.getElementById('selectedAppointmentTime');

        if(hiddenTime) hiddenTime.value = '';

        // If no doctor or date is selected, display all 5 slots as available by default
        if (!dentist || !date) {
            renderSlots([]);
            return;
        }

        // Dynamically compute application context path safely
        const contextPath = "<%= request.getContextPath() %>";
        const requestUrl = contextPath + "/GetBookedSlotsServlet?dentistName=" + encodeURIComponent(dentist) + "&appointmentDate=" + encodeURIComponent(date);

        fetch(requestUrl)
            .then(response => {
                if (!response.ok) {
                    throw new Error("Server returned status: " + response.status);
                }
                return response.json();
            })
            .then(bookedTimes => {
                renderSlots(Array.isArray(bookedTimes) ? bookedTimes : []);
            })
            .catch(error => {
                console.warn("AJAX slot query failed, rendering base slots:", error);
                renderSlots([]); // Graceful fallback
            });
    }

    function renderSlots(bookedTimes) {
        const slotGrid = document.getElementById('slotGrid');
        const hiddenTime = document.getElementById('selectedAppointmentTime');
        
        if (!slotGrid) return;
        slotGrid.innerHTML = '';

        FIXED_SLOTS.forEach(slot => {
            // Check if slot is already reserved
            const isBooked = Array.isArray(bookedTimes) && bookedTimes.some(bt => typeof bt === 'string' && bt.startsWith(slot.raw));

            const btn = document.createElement('button');
            btn.type = 'button';
            btn.disabled = isBooked;

            if (isBooked) {
                btn.className = 'slot-btn py-2.5 px-2 text-xs font-bold rounded-xl border text-center transition-all bg-rose-50 border-rose-200 text-rose-400 cursor-not-allowed line-through flex flex-col items-center justify-center gap-0.5';
                btn.innerHTML = '<span>' + slot.label + '</span><span class="text-[9px] font-black uppercase text-rose-500/80 no-underline">Booked</span>';
            } else {
                btn.className = 'slot-btn py-2.5 px-2 text-xs font-bold rounded-xl border text-center transition-all bg-white border-slate-200 text-slate-700 hover:border-orange-500 hover:bg-orange-50/60 shadow-sm flex flex-col items-center justify-center gap-0.5';
                btn.innerHTML = '<span>' + slot.label + '</span><span class="text-[9px] font-bold text-emerald-600">Available</span>';

                btn.onclick = () => {
                    document.querySelectorAll('.slot-btn:not([disabled])').forEach(b => {
                        b.classList.remove('bg-orange-600', 'text-white', 'border-orange-600', 'shadow-md');
                        b.classList.add('bg-white', 'text-slate-700', 'border-slate-200');
                    });
                    btn.classList.remove('bg-white', 'text-slate-700', 'border-slate-200');
                    btn.classList.add('bg-orange-600', 'text-white', 'border-orange-600', 'shadow-md');
                    
                    if (hiddenTime) hiddenTime.value = slot.raw;

                    const slotError = document.getElementById('slotError');
                    if (slotError) slotError.classList.add('hidden');
                };
            }

            slotGrid.appendChild(btn);
        });
    }

    function validateAndLockForm(formElement) {
        const patientIdInput = document.getElementById('patientId');
        const patientIdError = document.getElementById('patientIdError');
        const patientIdVal = patientIdInput ? patientIdInput.value.trim() : "";
        const hiddenTime = document.getElementById('selectedAppointmentTime');
        const slotError = document.getElementById('slotError');

        if (!patientIdVal || isNaN(patientIdVal) || parseInt(patientIdVal) <= 0) {
            if (patientIdError) patientIdError.classList.remove('hidden');
            if (patientIdInput) {
                patientIdInput.classList.add('border-rose-500', 'ring-1', 'ring-rose-500');
                patientIdInput.focus();
            }
            return false;
        }
        if (patientIdError) patientIdError.classList.add('hidden');

        if (!hiddenTime || !hiddenTime.value) {
            if (slotError) slotError.classList.remove('hidden');
            return false;
        }
        if (slotError) slotError.classList.add('hidden');

        const btn = document.getElementById('submitBtn');
        if(btn) {
            btn.disabled = true;
            btn.classList.remove('bg-orange-600', 'hover:bg-orange-500');
            btn.classList.add('bg-slate-300', 'cursor-not-allowed', 'text-slate-500');
            btn.innerHTML = '<i class="fa-solid fa-circle-notch animate-spin text-sm"></i> <span>Processing Allocation...</span>';
        }
        return true;
    }
</script>

<jsp:include page="../components/footer.jsp" />