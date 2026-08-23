<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Fetch the security role from the active session
    String userRole = (String) session.getAttribute("role");

    // Guard: Allow entry if the user is either designated as RECEPTIONIST or STAFF
    if(session.getAttribute("user") == null || 
       (!"RECEPTIONIST".equals(userRole) && !"STAFF".equals(userRole))) {
        
        response.sendRedirect("../login.jsp?error=Access Denied: Receptionist Session Required");
        return;
    }
%>
<jsp:include page="../components/header.jsp" />

<!-- Modern Styling Injections for Dynamic Glassmorphic Core Framework -->
<style>
    .glass-hud {
        background: rgba(224, 242, 254, 0.75); /* Soft sky-blue undertone */
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.5);
        box-shadow: 0 8px 32px 0 rgba(15, 23, 42, 0.08);
    }
    .glass-module {
        background: rgba(255, 255, 255, 0.85);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.6);
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    }
</style>

<!-- Deep Premium Dental Workspace Wrapper Background Panel -->
<div class="relative min-h-[85vh] rounded-3xl overflow-hidden p-4 sm:p-6 lg:p-10 border border-slate-200/60 shadow-xl bg-cover bg-center transition-all duration-700"
     style="background-image: url('https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=1920&q=80');">
    
    <!-- Sophisticated Color-Fade Underlay Matrix to Lock Typography Legibility -->
    <div class="absolute inset-0 z-0 bg-gradient-to-tr from-slate-950/85 via-slate-900/40 to-indigo-950/20"></div>

    <div class="relative z-10 max-w-6xl mx-auto space-y-6">

        <!-- Page Header & Operational HUD Badge -->
        <div class="glass-hud rounded-2xl border border-white/40 p-5 sm:p-6 shadow-lg shadow-slate-900/10">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                <div>
                    <div class="flex items-center gap-2">
                        <span class="inline-flex h-6 w-6 items-center justify-center rounded-md bg-indigo-600 text-white shadow-sm">
                            <i class="fa-solid fa-hospital-user text-[11px]"></i>
                        </span>
                        <h1 class="text-xl font-black tracking-tight text-slate-900 uppercase sm:text-2xl">Front-Desk Operations Hub</h1>
                    </div>
                    <p class="mt-1 text-xs sm:text-sm font-medium text-slate-500">Centralized platform to coordinate incoming patient workflows, scheduling matrices, and financial ledgers.</p>
                </div>
                
                <!-- Interactive Operational Status Role Pill -->
                <div class="inline-flex items-center gap-2.5 self-start md:self-center rounded-xl border border-slate-200 bg-white/90 px-4 py-2 text-xs font-bold text-slate-700 shadow-sm backdrop-blur-sm border-white/60">
                    <span class="relative flex h-2 w-2">
                        <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                        <span class="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
                    </span>
                    <span class="uppercase font-mono text-slate-600 tracking-wider">Node: <%= userRole %></span>
                </div>
            </div>
        </div>

        <!-- Dynamic Status Alert Banners Framework (Self-Dismissing CSS Animations) -->
        <div class="space-y-4">
            <% if(request.getParameter("msg") != null) { %>
                <div id="successToast" class="flex items-center justify-between rounded-2xl bg-emerald-500/95 border border-emerald-400/30 p-4 text-white shadow-xl backdrop-blur-md transition-all duration-300 animate-fade-in">
                    <div class="flex items-center gap-3">
                        <div class="flex h-8 w-8 items-center justify-center rounded-xl bg-white text-emerald-600 shadow-sm shrink-0">
                            <i class="fa-solid fa-circle-check text-sm"></i>
                        </div>
                        <p class="text-xs font-bold tracking-wide"><%= request.getParameter("msg") %></p>
                    </div>
                    <button onclick="dismissBanner('successToast')" type="button" class="rounded-xl p-1.5 text-emerald-100 hover:bg-white/10 hover:text-white transition-all">
                        <i class="fa-solid fa-xmark text-sm"></i>
                    </button>
                </div>
            <% } %>

            <% if(request.getParameter("error") != null) { %>
                <div id="errorToast" class="flex items-center justify-between rounded-2xl bg-rose-500/95 border border-rose-400/30 p-4 text-white shadow-xl backdrop-blur-md transition-all duration-300 animate-fade-in">
                    <div class="flex items-center gap-3">
                        <div class="flex h-8 w-8 items-center justify-center rounded-xl bg-white text-rose-600 shadow-sm shrink-0">
                            <i class="fa-solid fa-triangle-exclamation text-sm"></i>
                        </div>
                        <p class="text-xs font-bold tracking-wide"><%= request.getParameter("error") %></p>
                    </div>
                    <button onclick="dismissBanner('errorToast')" type="button" class="rounded-xl p-1.5 text-rose-100 hover:bg-white/10 hover:text-white transition-all">
                        <i class="fa-solid fa-xmark text-sm"></i>
                    </button>
                </div>
            <% } %>
        </div>

        <!-- Core Navigation Control Workspace Modules Grid (Updated Grid for 4 Modules) -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mt-6">
            
            <!-- Module 1: Patient Enrollment Portal -->
            <div class="glass-module group relative border border-white/50 rounded-2xl p-6 shadow-md transition-all duration-300 hover:-translate-y-1.5 hover:shadow-xl hover:shadow-indigo-950/20 hover:border-indigo-300/40 flex flex-col justify-between">
                <div class="absolute inset-x-0 top-0 h-1 bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-500 opacity-80 rounded-t-2xl"></div>
                
                <div class="mb-6">
                    <div class="inline-flex h-12 w-12 items-center justify-center rounded-xl bg-gradient-to-br from-indigo-50 to-indigo-100 border border-indigo-200/50 text-indigo-600 text-lg mb-4 shadow-inner transition-transform duration-500 group-hover:scale-110 group-hover:bg-indigo-600 group-hover:text-white">
                        <i class="fa-solid fa-user-plus"></i>
                    </div>
                    <h3 class="text-sm font-black text-slate-900 tracking-tight uppercase mb-2">Patient Registration</h3>
                    <p class="text-[11px] leading-relaxed font-semibold text-slate-500">Enroll fresh client cards into the clinic registry database and compile unique identity keys.</p>
                </div>
                <a href="register-patient.jsp" class="w-full text-center inline-flex items-center justify-center rounded-xl bg-slate-900 px-4 py-3 text-[11px] font-bold tracking-wider uppercase text-white shadow-md transition-all hover:bg-slate-800 active:scale-[0.98]">
                    <span>Register Patient</span>
                </a>
            </div>

            <!-- Module 2: Appointment Booking Engine -->
            <div class="glass-module group relative border border-white/50 rounded-2xl p-6 shadow-md transition-all duration-300 hover:-translate-y-1.5 hover:shadow-xl hover:shadow-teal-950/20 hover:border-teal-300/40 flex flex-col justify-between">
                <div class="absolute inset-x-0 top-0 h-1 bg-gradient-to-r from-teal-500 via-emerald-500 to-cyan-500 opacity-80 rounded-t-2xl"></div>
                
                <div class="mb-6">
                    <div class="inline-flex h-12 w-12 items-center justify-center rounded-xl bg-gradient-to-br from-teal-50 to-teal-100 border border-teal-200/50 text-teal-600 text-lg mb-4 shadow-inner transition-transform duration-500 group-hover:scale-110 group-hover:bg-teal-600 group-hover:text-white">
                        <i class="fa-solid fa-calendar-plus"></i>
                    </div>
                    <h3 class="text-sm font-black text-slate-900 tracking-tight uppercase mb-2">Book Appointment</h3>
                    <p class="text-[11px] leading-relaxed font-semibold text-slate-500">Map specialized calendar lines, adjust operational categories, and allocate surgeon slots.</p>
                </div>
                <a href="book-appointment.jsp" class="w-full text-center inline-flex items-center justify-center rounded-xl bg-teal-700 px-4 py-3 text-[11px] font-bold tracking-wider uppercase text-white shadow-md transition-all hover:bg-teal-600 active:scale-[0.98]">
                    <span>Book Appointment</span>
                </a>
            </div>

            <!-- NEW Module 3: View Appointments Directory -->
            <div class="glass-module group relative border border-white/50 rounded-2xl p-6 shadow-md transition-all duration-300 hover:-translate-y-1.5 hover:shadow-xl hover:shadow-sky-950/20 hover:border-sky-300/40 flex flex-col justify-between">
                <div class="absolute inset-x-0 top-0 h-1 bg-gradient-to-r from-sky-500 via-blue-500 to-indigo-500 opacity-80 rounded-t-2xl"></div>
                
                <div class="mb-6">
                    <div class="inline-flex h-12 w-12 items-center justify-center rounded-xl bg-gradient-to-br from-sky-50 to-sky-100 border border-sky-200/50 text-sky-600 text-lg mb-4 shadow-inner transition-transform duration-500 group-hover:scale-110 group-hover:bg-sky-600 group-hover:text-white">
                        <i class="fa-solid fa-calendar-check"></i>
                    </div>
                    <h3 class="text-sm font-black text-slate-900 tracking-tight uppercase mb-2">View Appointments</h3>
                    <p class="text-[11px] leading-relaxed font-semibold text-slate-500">Inspect full consultation logs, verify assigned dental surgeons, and monitor booking status.</p>
                </div>
                <a href="view-appointments.jsp" class="w-full text-center inline-flex items-center justify-center rounded-xl bg-sky-700 px-4 py-3 text-[11px] font-bold tracking-wider uppercase text-white shadow-md transition-all hover:bg-sky-600 active:scale-[0.98]">
                    <span>View Directory</span>
                </a>
            </div>

            <!-- Module 4: Financial Settlement Billing Ledger -->
            <div class="glass-module group relative border border-white/50 rounded-2xl p-6 shadow-md transition-all duration-300 hover:-translate-y-1.5 hover:shadow-xl hover:shadow-amber-950/20 hover:border-amber-300/40 flex flex-col justify-between">
                <div class="absolute inset-x-0 top-0 h-1 bg-gradient-to-r from-amber-500 via-orange-500 to-yellow-500 opacity-80 rounded-t-2xl"></div>
                
                <div class="mb-6">
                    <div class="inline-flex h-12 w-12 items-center justify-center rounded-xl bg-gradient-to-br from-amber-50 to-amber-100 border border-amber-200/50 text-amber-600 text-lg mb-4 shadow-inner transition-transform duration-500 group-hover:scale-110 group-hover:bg-amber-600 group-hover:text-white">
                        <i class="fa-solid fa-credit-card"></i>
                    </div>
                    <h3 class="text-sm font-black text-slate-900 tracking-tight uppercase mb-2">Billing &amp; Checkout</h3>
                    <p class="text-[11px] leading-relaxed font-semibold text-slate-500">Monitor active payment logs, clear invoice balances, and close treatment balance sheets.</p>
                </div>
                <a href="billing.jsp" class="w-full text-center inline-flex items-center justify-center rounded-xl bg-amber-600 px-4 py-3 text-[11px] font-bold tracking-wider uppercase text-white shadow-md transition-all hover:bg-amber-500 active:scale-[0.98]">
                    <span>Settle Ledger Bills</span>
                </a>
            </div>

        </div>

        <!-- Session Termination Actions Platform Area -->
        <div class="text-center pt-8">
            <a href="${pageContext.request.contextPath}/AuthServlet?action=logout" 
               class="inline-flex items-center gap-2 rounded-xl border border-rose-200/40 bg-rose-500/10 hover:bg-rose-500/20 px-5 py-2.5 text-xs font-bold text-rose-200 shadow-sm transition-all duration-200 active:scale-[0.97] backdrop-blur-md">
                <i class="fa-solid fa-power-off text-[11px] text-rose-400"></i>
                <span>Securely Terminate Session (Logout)</span>
            </a>
        </div>

    </div>
</div>

<!-- Interface UI Mechanics Controller Scripts -->
<script>
    // Smooth toast removal engine logic
    function dismissBanner(elementId) {
        const toast = document.getElementById(elementId);
        if(toast) {
            toast.style.opacity = '0';
            toast.style.transform = 'translateY(-8px)';
            setTimeout(() => toast.remove(), 250);
        }
    }
    
    // Auto-clean notifications loop at 5000ms thresholds
    setTimeout(() => { dismissBanner('successToast'); }, 5000);
    setTimeout(() => { dismissBanner('errorToast'); }, 5000);
</script>

<jsp:include page="../components/footer.jsp" />