<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("user") == null || !"RECEPTIONIST".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=Access Denied: Receptionist Session Required");
        return;
    }
%>
<jsp:include page="../components/header.jsp" />

<!-- Advanced Design Token Underlays for Glassmorphic Front-Desk Intake Architecture -->
<style>
    .glass-intake-hud {
        background: rgba(224, 242, 254, 0.75); /* Soft sky-blue undertone */
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.5);
        box-shadow: 0 8px 32px 0 rgba(15, 23, 42, 0.08);
    }
    .glass-intake-card {
        background: rgba(255, 255, 255, 0.85);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.6);
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    }
</style>

<!-- High-Fidelity Modern Dental Clinic Backdrop Container -->
<div class="relative min-h-[88vh] rounded-3xl overflow-hidden p-4 sm:p-6 lg:p-10 border border-slate-200/60 shadow-xl bg-cover bg-center transition-all duration-700"
     style="background-image: url('https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=1920&q=80');">
    
    <!-- Precise Color Masking Layer to Stabilize Form Component Contrast Vectors -->
    <div class="absolute inset-0 z-0 bg-gradient-to-tr from-slate-950/85 via-slate-900/40 to-indigo-950/20"></div>

    <div class="relative z-10 max-w-md mx-auto space-y-6">

        <!-- Front-Desk Profile Workspace Header Navigation Block -->
        <div class="glass-intake-hud rounded-2xl border border-white/40 p-5 shadow-lg shadow-slate-900/10">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
                <div>
                    <div class="flex items-center gap-2">
                        <span class="inline-flex h-6 w-6 items-center justify-center rounded-md bg-indigo-600 text-white shadow-sm shadow-indigo-600/20">
                            <i class="fa-solid fa-address-book text-[11px]"></i>
                        </span>
                        <h1 class="text-xl font-black tracking-tight text-slate-900 uppercase sm:text-2xl">Patient Intake</h1>
                    </div>
                    <p class="mt-1 text-xs font-medium text-slate-500">Create clinical records and register contact profiles.</p>
                </div>
                
                <!-- Interactive Action Return Anchor -->
                <a href="dashboard.jsp" class="inline-flex items-center gap-2 self-start sm:self-center rounded-xl border border-slate-200 bg-white/90 px-4 py-2 text-xs font-bold text-slate-700 shadow-sm transition-all hover:bg-slate-50 hover:text-slate-900 active:scale-[0.98] backdrop-blur-sm">
                    <i class="fa-solid fa-arrow-left-long text-slate-400"></i>
                    <span>Cancel View</span>
                </a>
            </div>
        </div>

        <!-- Main Intake Card Container -->
        <div class="glass-intake-card rounded-2xl border border-white/50 shadow-2xl overflow-hidden mb-12">
            
            <!-- Premium Dynamic Identity Brand Accent Strip -->
            <div class="h-1.5 bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500"></div>

            <div class="p-6 sm:p-8">
                <!-- Error Alert Message Handling Framework -->
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

                <form action="${pageContext.request.contextPath}/PatientServlet" method="post" onsubmit="return validateAndLock(this)" class="space-y-5">
                    <input type="hidden" name="action" value="register">
                    
                    <!-- Patient Full Name Input Module -->
                    <div class="group">
                        <label class="block text-[10px] font-black tracking-wider text-slate-400 mb-2 uppercase group-focus-within:text-indigo-600 transition-colors">Full Name</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400 group-focus-within:text-indigo-500 transition-colors">
                                <i class="fa-solid fa-signature text-xs"></i>
                            </span>
							 <input type="text" id="patientName" name="name" placeholder="e.g., John Doe" 
							       class="w-full rounded-xl border border-slate-200/80 bg-slate-50/60 py-2.5 pl-10 pr-4 text-xs font-bold text-slate-800 placeholder-slate-400 focus:border-indigo-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500 transition-all shadow-inner" required>
                        </div>
                    </div>

                    <!-- Contact Number Form Field Node (Strict 10-Digit Validation) -->
                    <div class="group">
                        <div class="flex justify-between items-center mb-2">
                            <label class="block text-[10px] font-black tracking-wider text-slate-400 uppercase group-focus-within:text-indigo-600 transition-colors">Contact Number</label>
                            <span class="text-[10px] font-bold text-indigo-500">Exactly 10 Digits</span>
                        </div>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400 group-focus-within:text-indigo-500 transition-colors">
                                <i class="fa-solid fa-phone text-xs"></i>
                            </span>
                            <input type="tel" 
                                   id="contactNumber"
                                   name="contactNumber" 
                                   maxlength="10" 
                                   pattern="[0-9]{10}"
                                   oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                                   placeholder="e.g., 0771234567" 
                                   title="Please enter exactly 10 numeric digits without letters, spaces, or special characters."
                                   class="w-full rounded-xl border border-slate-200/80 bg-slate-50/60 py-2.5 pl-10 pr-4 text-xs font-bold text-slate-800 placeholder-slate-400 focus:border-indigo-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500 transition-all font-mono shadow-inner" required>
                        </div>
                    </div>

                    <!-- Patient Address Form Field Node -->
                    <div class="group">
                        <label class="block text-[10px] font-black tracking-wider text-slate-400 mb-2 uppercase group-focus-within:text-indigo-600 transition-colors">Address</label>
                        <div class="relative">
                            <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400 group-focus-within:text-indigo-500 transition-colors">
                                <i class="fa-solid fa-location-dot text-xs"></i>
                            </span>
                            <input type="text" name="address" placeholder="e.g., 123 Main Street, Colombo" 
                                   class="w-full rounded-xl border border-slate-200/80 bg-slate-50/60 py-2.5 pl-10 pr-4 text-xs font-bold text-slate-800 placeholder-slate-400 focus:border-indigo-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500 transition-all shadow-inner" required>
                        </div>
                    </div>

                    <!-- Registration Form Action Frame -->
                    <div class="pt-2">
                        <button type="submit" id="submitBtn" 
                                class="w-full inline-flex items-center justify-center gap-2 rounded-xl bg-indigo-600 px-5 py-3.5 text-xs font-black tracking-wide uppercase text-white shadow-md shadow-indigo-600/10 transition-all hover:bg-indigo-500 hover:shadow-lg active:scale-[0.98] focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2">
                            <i class="fa-solid fa-address-book text-sm"></i>
                            <span>Save Patient Profile</span>
                        </button>
                    </div>
                    
                </form>
            </div>
            
            <!-- Contextual Operational Security Alert Footer Banner -->
            <div class="p-4 bg-slate-100/70 border-t border-slate-200/50 flex gap-3 items-start backdrop-blur-sm">
                <i class="fa-solid fa-key text-slate-500 text-xs mt-0.5"></i>
                <p class="text-[10px] font-bold tracking-wide uppercase text-slate-500 leading-normal">
                    System Alert: Form generation initializes permanent data objects within the clinical storage pools. Verify credentials before saving profiles.
                </p>
            </div>
        </div>

    </div>
</div>

<script>
    // Smooth dismiss engine for notification panels
    function dismissError() {
        const toast = document.getElementById('errorToast');
        if(toast) {
            toast.style.opacity = '0';
            setTimeout(() => toast.remove(), 300);
        }
    }

    // Client-side validation check + Submit button locker
    function validateAndLock(formElement) {
        const nameInput = document.getElementById('patientName');
        const contactInput = document.getElementById('contactNumber');
        
        const nameVal = nameInput ? nameInput.value.trim() : '';
        const contactVal = contactInput ? contactInput.value.trim() : '';

        // 1. Strict 10-Digit Validation Check
        const digitRegex = /^[0-9]{10}$/;
        if (!digitRegex.test(contactVal)) {
            alert('Contact number must be exactly 10 numeric digits without letters, spaces, or special characters.');
            contactInput.focus();
            return false;
        }

        // 2. Lock Submit Button to prevent double-click submissions
        const btn = document.getElementById('submitBtn');
        if(btn) {
            btn.disabled = true;
            btn.classList.remove('bg-indigo-600', 'hover:bg-indigo-500');
            btn.classList.add('bg-slate-300', 'cursor-not-allowed', 'text-slate-500');
            btn.innerHTML = `<i class="fa-solid fa-circle-notch animate-spin text-sm"></i> <span>Saving Context Node...</span>`;
        }

        return true;
    }
</script>

<jsp:include page="../components/footer.jsp" />