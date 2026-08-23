<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Security Guard: Prevent session leaks or access bypasses
    if(session.getAttribute("user") == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=Access Denied: Administrative Session Required");
        return;
    }
%>
<jsp:include page="../components/header.jsp" />

<!-- Modern Styling Injections for Advanced Aesthetic Blur Layers -->
<style>
.glass-panel {
        background: rgba(224, 242, 254, 0.75); /* Soft sky-blue undertone */
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.5);
        box-shadow: 0 8px 32px 0 rgba(15, 23, 42, 0.08);
    }
    
    /* Premium Interactive Glass Cards */
    .glass-card {
        background: rgba(255, 255, 255, 0.85);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.6);
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    }
</style>

<!-- Deep Premium Dental Workspace Wrapper Background Panel -->
<div class="relative min-h-[80vh] rounded-3xl overflow-hidden p-6 sm:p-8 lg:p-10 border border-slate-200/60 shadow-xl bg-cover bg-center transition-all duration-700"
     style="background-image: url('https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=1920&q=80');">
    
    <!-- Sophisticated Gradient Shading Layer to Anchor Contrast Parameters -->
    <div class="absolute inset-0 z-0 bg-gradient-to-tr from-slate-900/90 via-slate-900/40 to-indigo-950/20"></div>

    <div class="relative z-10 space-y-8">
        <!-- Page Title Block & Clock Glass Header HUD -->
        <div class="glass-panel rounded-2xl border border-white/40 p-5 sm:p-6 shadow-lg shadow-slate-900/10">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                <div>
                    <div class="flex items-center gap-2">
                        <span class="inline-flex h-6 w-6 items-center justify-center rounded-md bg-indigo-600 text-white shadow-sm">
                            <i class="fa-solid fa-shield-halved text-[11px]"></i>
                        </span>
                        <h1 class="text-xl font-black tracking-tight text-slate-900 uppercase sm:text-2xl">Administrative Control Hub</h1>
                    </div>
                    <p class="mt-1 text-xs sm:text-sm font-medium text-slate-500">Manage global encryption metrics, staff credential pools, and clinic operation matrices.</p>
                </div>
                
                <!-- Advanced Dynamic Live Clock Display Box -->
                <div class="inline-flex items-center gap-2.5 self-start md:self-center rounded-xl bg-indigo-600/90 px-4 py-2 text-xs font-bold text-white shadow-md shadow-indigo-600/20 backdrop-blur-md transition-all duration-300 hover:scale-105 border border-indigo-400/30 font-mono tracking-wide">
                    <i class="fa-regular fa-clock animate-spin-slow"></i>
                    <span id="liveClock">Loading Chronos...</span>
                </div>
            </div>
        </div>

        <!-- Dynamic Action Messages/Notifications System -->
        <% if(request.getParameter("msg") != null) { %>
            <div id="statusToast" class="flex items-center justify-between rounded-2xl bg-emerald-500/95 border border-emerald-400/40 p-4 text-white shadow-xl backdrop-blur-md transition-all duration-300 animate-fade-in animate-bounce-subtle max-w-4xl mx-auto">
                <div class="flex items-center gap-3">
                    <div class="flex h-8 w-8 items-center justify-center rounded-xl bg-white text-emerald-600 shadow-sm shrink-0">
                        <i class="fa-solid fa-circle-check text-sm"></i>
                    </div>
                    <p class="text-xs font-bold tracking-wide"><%= request.getParameter("msg") %></p>
                </div>
                <button onclick="dismissToast()" class="rounded-xl p-1.5 text-emerald-100 hover:bg-white/10 hover:text-white transition-all">
                    <i class="fa-solid fa-xmark text-sm"></i>
                </button>
            </div>
        <% } %>

        <!-- Premium Navigation Grid Dashboard (Reverse Pyramid Layout) -->
        <div class="flex flex-col gap-6 max-w-4xl mx-auto">
            
            <!-- Top Row: 2 Side-by-Side Cards -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-6 w-full">
                
                <!-- Card 1: Staff Account Registries -->
                <div class="glass-card group relative overflow-hidden rounded-2xl border border-white/50 p-6 sm:p-8 shadow-md transition-all duration-300 hover:-translate-y-1.5 hover:shadow-xl hover:shadow-blue-950/20 hover:border-blue-300/40">
                    <!-- Top border glow highlight layout -->
                    <div class="absolute inset-x-0 top-0 h-1.5 bg-gradient-to-r from-blue-500 via-sky-500 to-indigo-500 opacity-80 group-hover:h-2 transition-all"></div>
                    
                    <div class="flex flex-col items-center text-center">
                        <!-- Icon Wrapper Box -->
                        <div class="mb-5 flex h-16 w-16 items-center justify-center rounded-2xl bg-gradient-to-br from-blue-50 to-sky-100 text-blue-600 shadow-inner transition-transform duration-500 group-hover:rotate-[360deg] group-hover:scale-110 border border-blue-200/50">
                            <i class="fa-solid fa-users-gear text-2xl"></i>
                        </div>
                        
                        <h3 class="text-base font-extrabold text-slate-900 tracking-tight uppercase">Staff Account Registries</h3>
                        <p class="mt-2 text-xs leading-relaxed text-slate-500 font-medium max-w-xs">
                            Audit secure credential tokens, configure roles, inspect login trails, and maintain employee identity vaults.
                        </p>
                        
                        <a href="manage-staff.jsp" class="mt-6 w-full sm:w-auto inline-flex items-center justify-center gap-2 rounded-xl bg-slate-900 px-6 py-3 text-xs font-bold text-white shadow-md transition-all hover:bg-slate-800 hover:shadow-lg active:scale-[0.98] tracking-wider uppercase">
                            <span>Open Staff Database</span>
                            <i class="fa-solid fa-arrow-right-long text-[10px] transition-transform group-hover:translate-x-1"></i>
                        </a>
                    </div>
                </div>

                <!-- Card 2: Treatment Configuration Fees -->
                <div class="glass-card group relative overflow-hidden rounded-2xl border border-white/50 p-6 sm:p-8 shadow-md transition-all duration-300 hover:-translate-y-1.5 hover:shadow-xl hover:shadow-amber-950/20 hover:border-amber-300/40">
                    <!-- Top border glow highlight layout -->
                    <div class="absolute inset-x-0 top-0 h-1.5 bg-gradient-to-r from-amber-500 via-orange-500 to-yellow-500 opacity-80 group-hover:h-2 transition-all"></div>
                    
                    <div class="flex flex-col items-center text-center">
                        <!-- Icon Wrapper Box -->
                        <div class="mb-5 flex h-16 w-16 items-center justify-center rounded-2xl bg-gradient-to-br from-amber-50 to-orange-100 text-amber-600 shadow-inner transition-transform duration-500 group-hover:scale-110 group-hover:animate-pulse border border-amber-200/50">
                            <i class="fa-solid fa-file-invoice-dollar text-2xl"></i>
                        </div>
                        
                        <h3 class="text-base font-extrabold text-slate-900 tracking-tight uppercase">Fee Matrix Pricing Engine</h3>
                        <p class="mt-2 text-xs leading-relaxed text-slate-500 font-medium max-w-xs">
                            Configure baseline treatment values managed dynamically via the central factory application logic core.
                        </p>
                        
                        <a href="treatment-fees.jsp" class="mt-6 w-full sm:w-auto inline-flex items-center justify-center gap-2 rounded-xl bg-amber-600 px-6 py-3 text-xs font-bold text-white shadow-md transition-all hover:bg-amber-500 hover:shadow-lg active:scale-[0.98] tracking-wider uppercase">
                            <span>View Cost Architectures</span>
                            <i class="fa-solid fa-arrow-right-long text-[10px] transition-transform group-hover:translate-x-1"></i>
                        </a>
                    </div>
                </div>

            </div>

            <!-- Bottom Row: Centered Single Card (Reverse Pyramid Point) -->
            <div class="flex justify-center w-full">
                <!-- Card 3: Doctor Channeling & Treatment Mapping -->
                <div class="glass-card group relative overflow-hidden rounded-2xl border border-white/50 p-6 sm:p-8 shadow-md transition-all duration-300 hover:-translate-y-1.5 hover:shadow-xl hover:shadow-teal-950/20 hover:border-teal-300/40 w-full sm:w-[calc(50%-0.75rem)]">
                    <div class="absolute inset-x-0 top-0 h-1.5 bg-gradient-to-r from-teal-500 via-emerald-500 to-cyan-500 opacity-80 group-hover:h-2 transition-all"></div>
                    
                    <div class="flex flex-col items-center text-center">
                        <div class="mb-5 flex h-16 w-16 items-center justify-center rounded-2xl bg-gradient-to-br from-teal-50 to-emerald-100 text-teal-600 shadow-inner transition-transform duration-500 group-hover:scale-110 border border-teal-200/50">
                            <i class="fa-solid fa-user-doctor text-2xl"></i>
                        </div>
                        
                        <h3 class="text-base font-extrabold text-slate-900 tracking-tight uppercase">Doctor Management</h3>
                        <p class="mt-2 text-xs leading-relaxed text-slate-500 font-medium max-w-xs">
                            Manage channelable doctors, toggle active statuses, and assign treatment authorization maps.
                        </p>
                        
                        <a href="manage-doctors.jsp" class="mt-6 w-full sm:w-auto inline-flex items-center justify-center gap-2 rounded-xl bg-teal-600 px-6 py-3 text-xs font-bold text-white shadow-md transition-all hover:bg-teal-500 hover:shadow-lg active:scale-[0.98] tracking-wider uppercase">
                            <span>Manage Doctors</span>
                            <i class="fa-solid fa-arrow-right-long text-[10px] transition-transform group-hover:translate-x-1"></i>
                        </a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- Contextual Scripts for Interface Micro-Mechanics -->
<script>
    // Smooth toast dismissal engine logic
    function dismissToast() {
        const toast = document.getElementById('statusToast');
        if(toast) {
            toast.style.opacity = '0';
            toast.style.transform = 'translateY(-10px)';
            setTimeout(() => toast.remove(), 300);
        }
    }
    
    // Safety auto-dismiss configuration triggers automatically at 6000ms
    setTimeout(() => {
        dismissToast();
    }, 6000);

    // Live Administrative HUD Clock Runner
    function updateClock() {
        const now = new Date();
        const formattedTime = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true });
        const liveClockElement = document.getElementById('liveClock');
        if (liveClockElement) {
            liveClockElement.textContent = formattedTime;
        }
    }
    setInterval(updateClock, 1000);
    updateClock(); // Boot sequence pull
</script>

<jsp:include page="../components/footer.jsp" />