<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Session Guard: Ensure user is logged in
    if(session.getAttribute("user") == null) {
        response.sendRedirect("../login.jsp?error=Please log in to access the system guide.");
        return;
    }
%>
<jsp:include page="../components/header.jsp" />

<!-- Tailwind CSS & FontAwesome CDNs -->
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<!-- Custom Styling for Dental Background & Glassmorphism -->
<style>
    .glass-help-hud {
          background: rgba(224, 242, 254, 0.75); /* Soft sky-blue undertone */
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
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .accordion-content {
        max-height: 0;
        overflow: hidden;
        transition: max-height 0.35s cubic-bezier(0, 1, 0, 1);
    }
    
    .accordion-content.open {
        max-height: 1200px;
        transition: max-height 0.5s ease-in-out;
    }
</style>

<!-- Main Container with Dental Backdrop -->
<div class="relative min-h-[88vh] rounded-3xl overflow-hidden p-4 sm:p-6 lg:p-10 border border-slate-200/60 shadow-xl bg-cover bg-center transition-all duration-700"
     style="background-image: url('https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=1920&q=80');">
     
      <div class="absolute inset-0 z-0 bg-gradient-to-tr from-slate-950/85 via-slate-900/40 to-emerald-950/20"></div>
    

    <div class="relative z-10 max-w-6xl mx-auto space-y-8">

        <!-- Header / Hero Section -->
        <div class="glass-help-hud rounded-3xl p-6 sm:p-10 shadow-xl text-center relative overflow-hidden">
            <div class="absolute -right-10 -top-10 w-40 h-40 bg-indigo-500/10 rounded-full blur-2xl"></div>
            <div class="absolute -left-10 -bottom-10 w-40 h-40 bg-cyan-500/10 rounded-full blur-2xl"></div>

            <span class="inline-flex items-center gap-2 rounded-full bg-indigo-100 px-3 py-1 text-xs font-black text-indigo-700 uppercase tracking-widest mb-3">
                <i class="fa-solid fa-tooth"></i> Sunrise Dental Staff Portal
            </span>
            <h1 class="text-2xl sm:text-4xl font-black text-slate-900 tracking-tight uppercase">Helpdesk & System Guide</h1>
            <p class="mt-2 text-xs sm:text-sm font-medium text-slate-600 max-w-xl mx-auto">
                Step-by-step instructions for clinical intake, appointment lookup, and billing calculations.
            </p>

            <!-- Interactive Search Bar + Controls -->
            <div class="mt-6 max-w-xl mx-auto relative space-y-3">
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-slate-400">
                        <i class="fa-solid fa-magnifying-glass text-sm"></i>
                    </span>
                    <input type="text" id="helpSearch" onkeyup="filterHelpTopics()" placeholder="Search guide (e.g., 'register patient', 'billing', 'print receipt')..." 
                           class="w-full pl-11 pr-24 py-3.5 bg-white/90 border border-slate-200 rounded-2xl text-xs font-bold text-slate-800 placeholder-slate-400 shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 transition-all">
                    <span id="searchResultCount" class="absolute right-3 top-3 text-[10px] font-bold text-indigo-600 bg-indigo-50 px-2 py-1 rounded-lg">All Topics</span>
                </div>

                <!-- One-Touch Accordion Controls -->
                <div class="flex justify-center gap-3 text-[11px] font-bold">
                    <button onclick="toggleAllAccordions(true)" class="text-indigo-600 hover:text-indigo-800 bg-white/80 px-3 py-1 rounded-lg border border-slate-200 shadow-xs">
                        <i class="fa-solid fa-angles-down mr-1"></i> Expand All
                    </button>
                    <button onclick="toggleAllAccordions(false)" class="text-slate-500 hover:text-slate-700 bg-white/80 px-3 py-1 rounded-lg border border-slate-200 shadow-xs">
                        <i class="fa-solid fa-angles-up mr-1"></i> Collapse All
                    </button>
                </div>
            </div>
        </div>

        <!-- Workflow Step Cards -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <a href="#sec-auth" class="glass-card rounded-2xl p-5 shadow-sm hover:shadow-md transition-all group border-l-4 border-l-slate-600">
                <div class="flex items-center justify-between">
                    <div class="p-2.5 rounded-xl bg-slate-100 text-slate-700 group-hover:bg-slate-800 group-hover:text-white transition-colors">
                        <i class="fa-solid fa-shield-halved text-lg"></i>
                    </div>
                    <span class="text-[10px] font-black text-slate-400 uppercase">Step 01</span>
                </div>
                <h3 class="mt-3 text-sm font-black text-slate-900 uppercase">1. System Access</h3>
                <p class="text-[11px] text-slate-500 mt-1 font-medium">Authentication & safety.</p>
            </a>

            <a href="#sec-register" class="glass-card rounded-2xl p-5 shadow-sm hover:shadow-md transition-all group border-l-4 border-l-indigo-500">
                <div class="flex items-center justify-between">
                    <div class="p-2.5 rounded-xl bg-indigo-50 text-indigo-600 group-hover:bg-indigo-600 group-hover:text-white transition-colors">
                        <i class="fa-solid fa-user-plus text-lg"></i>
                    </div>
                    <span class="text-[10px] font-black text-indigo-500 uppercase">Step 02</span>
                </div>
                <h3 class="mt-3 text-sm font-black text-slate-900 uppercase">2. Intake & Register</h3>
                <p class="text-[11px] text-slate-500 mt-1 font-medium">Adding patients & IDs.</p>
            </a>

            <a href="#sec-lookup" class="glass-card rounded-2xl p-5 shadow-sm hover:shadow-md transition-all group border-l-4 border-l-cyan-500">
                <div class="flex items-center justify-between">
                    <div class="p-2.5 rounded-xl bg-cyan-50 text-cyan-600 group-hover:bg-cyan-600 group-hover:text-white transition-colors">
                        <i class="fa-solid fa-folder-open text-lg"></i>
                    </div>
                    <span class="text-[10px] font-black text-cyan-500 uppercase">Step 03</span>
                </div>
                <h3 class="mt-3 text-sm font-black text-slate-900 uppercase">3. Record Search</h3>
                <p class="text-[11px] text-slate-500 mt-1 font-medium">Lookup history by ID.</p>
            </a>

            <a href="#sec-billing" class="glass-card rounded-2xl p-5 shadow-sm hover:shadow-md transition-all group border-l-4 border-l-emerald-500">
                <div class="flex items-center justify-between">
                    <div class="p-2.5 rounded-xl bg-emerald-50 text-emerald-600 group-hover:bg-emerald-600 group-hover:text-white transition-colors">
                        <i class="fa-solid fa-file-invoice-dollar text-lg"></i>
                    </div>
                    <span class="text-[10px] font-black text-emerald-500 uppercase">Step 04</span>
                </div>
                <h3 class="mt-3 text-sm font-black text-slate-900 uppercase">4. Billing & Receipt</h3>
                <p class="text-[11px] text-slate-500 mt-1 font-medium">Calculations & printing.</p>
            </a>
        </div>

        <!-- Interactive Knowledge Base Sections -->
        <div class="space-y-4" id="accordionContainer">

            <!-- Section 1: Authentication -->
		<div class="help-card glass-card rounded-2xl overflow-hidden shadow-sm" id="sec-auth">
		    <button onclick="toggleAccordion('acc-1')" class="w-full flex items-center justify-between p-5 text-left bg-white/50 hover:bg-white/80 transition-colors">
		        <div class="flex items-center gap-3">
		            <span class="flex h-8 w-8 items-center justify-center rounded-lg bg-slate-800 text-white font-bold text-xs">1</span>
		            <div>
		                <h2 class="text-sm font-black text-slate-900 uppercase tracking-wide">System Authentication & Security</h2>
		                <p class="text-[11px] text-slate-500 font-medium">Secure login and session safeguards.</p>
		            </div>
		        </div>
		        <i id="icon-acc-1" class="fa-solid fa-chevron-down text-slate-400 transition-transform duration-300"></i>
		    </button>
		    
		    <div id="acc-1" class="accordion-content">
		        <div class="p-6 border-t border-slate-200/60 bg-white/50 space-y-4 text-xs font-medium text-slate-700">
		            <div class="grid grid-cols-1 lg:grid-cols-3 gap-4 items-center">
		                <div class="lg:col-span-2 space-y-3">
		                    <ol class="list-decimal pl-5 space-y-2">
		                        <li>Access the <strong>Login Portal</strong> (<code>login.jsp</code>).</li>
		                        <li>Select your assigned role (<strong>Receptionist</strong> or <strong>Admin / Doctor</strong>).</li>
		                        <li>Enter credentials verified against system database encryption.</li>
		                    </ol>
		                    <div class="p-3 bg-amber-50 rounded-xl border border-amber-200 text-amber-800 text-[11px] flex gap-2 items-center">
		                        <i class="fa-solid fa-triangle-exclamation text-amber-600"></i>
		                        <span><strong>Security Rule:</strong> Always log out before leaving your desk to protect patient data privacy.</span>
		                    </div>
		                </div>
		
		                <!-- Visual Graphic Added Here -->
		                <div class="bg-white p-3 rounded-2xl border border-slate-200 text-center shadow-sm">
		                    <img src="https://images.unsplash.com/photo-1555774698-0b77e0d5fac6?auto=format&fit=crop&w=400&q=80" alt="Secure Authentication System" class="rounded-xl h-36 w-full object-cover mb-2">
		                    <span class="text-[10px] font-bold text-slate-400 uppercase">Fig 1. Staff Security & Authentication</span>
		                </div>
		            </div>
		        </div>
		    </div>
		</div>

            <!-- Section 2: Patient Registration with Visual Visuals -->
            <div class="help-card glass-card rounded-2xl overflow-hidden shadow-sm" id="sec-register">
                <button onclick="toggleAccordion('acc-2')" class="w-full flex items-center justify-between p-5 text-left bg-white/50 hover:bg-white/80 transition-colors">
                    <div class="flex items-center gap-3">
                        <span class="flex h-8 w-8 items-center justify-center rounded-lg bg-indigo-600 text-white font-bold text-xs">2</span>
                        <div>
                            <h2 class="text-sm font-black text-slate-900 uppercase tracking-wide">Registering New Patient & Appointment</h2>
                            <p class="text-[11px] text-slate-500 font-medium">Clinical scheduling & profile entry.</p>
                        </div>
                    </div>
                    <i id="icon-acc-2" class="fa-solid fa-chevron-down text-slate-400 transition-transform duration-300"></i>
                </button>
                
                <div id="acc-2" class="accordion-content">
                    <div class="p-6 border-t border-slate-200/60 bg-white/50 space-y-4 text-xs font-medium text-slate-700">
                        <div class="grid grid-cols-1 lg:grid-cols-3 gap-4 items-center">
                            <div class="lg:col-span-2 space-y-3">
                                <p>Fill in patient registration fields accurately:</p>
                                <ul class="list-disc pl-5 space-y-1.5 text-slate-600">
                                    <li><strong>Full Name:</strong> Primary identification.</li>
                                    <li><strong>Contact Number:</strong> Must be 10 digits (`077XXXXXXX`).</li>
                                    <li><strong>Assigned Doctor:</strong> Select consulting dentist.</li>
                                </ul>
                                <div class="p-3 bg-indigo-50 rounded-xl border border-indigo-200 text-indigo-900 text-[11px]">
                                    <i class="fa-solid fa-circle-info mr-1"></i> System automatically generates an <strong>Appointment ID Number</strong> upon submission.
                                </div>
                            </div>
                            
                            <!-- Visual Graphic -->
                            <div class="bg-white p-3 rounded-2xl border border-slate-200 text-center shadow-sm">
                                <img src="https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?auto=format&fit=crop&w=400&q=80" alt="Patient Check-in Visual" class="rounded-xl h-36 w-full object-cover mb-2">
                                <span class="text-[10px] font-bold text-slate-400 uppercase">Fig 1. Patient Intake Process</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Section 3: Record Lookup -->
            <div class="help-card glass-card rounded-2xl overflow-hidden shadow-sm" id="sec-lookup">
                <button onclick="toggleAccordion('acc-3')" class="w-full flex items-center justify-between p-5 text-left bg-white/50 hover:bg-white/80 transition-colors">
                    <div class="flex items-center gap-3">
                        <span class="flex h-8 w-8 items-center justify-center rounded-lg bg-cyan-600 text-white font-bold text-xs">3</span>
                        <div>
                            <h2 class="text-sm font-black text-slate-900 uppercase tracking-wide">Appointment & Medical History Search</h2>
                            <p class="text-[11px] text-slate-500 font-medium">Lookup patient records by ID.</p>
                        </div>
                    </div>
                    <i id="icon-acc-3" class="fa-solid fa-chevron-down text-slate-400 transition-transform duration-300"></i>
                </button>
                
                <div id="acc-3" class="accordion-content">
                    <div class="p-6 border-t border-slate-200/60 bg-white/50 space-y-4 text-xs font-medium text-slate-700">
                        <div class="grid grid-cols-1 lg:grid-cols-3 gap-4 items-center">
                            <div class="lg:col-span-2 space-y-2">
                                <ol class="list-decimal pl-5 space-y-2">
                                    <li>Open <strong>Appointment Search</strong> from your navigation menu.</li>
                                    <li>Enter the patient's assigned <strong>Appointment ID</strong>.</li>
                                    <li>View treatment history, active schedules, and status logs.</li>
                                </ol>
                            </div>
                            
                            <!-- Visual Graphic -->
                            <div class="bg-white p-3 rounded-2xl border border-slate-200 text-center shadow-sm">
                                <img src="https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&w=400&q=80" alt="Record Lookup Visual" class="rounded-xl h-36 w-full object-cover mb-2">
                                <span class="text-[10px] font-bold text-slate-400 uppercase">Fig 2. Digital Record System</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Section 4: Billing + Quick Calculator Tool -->
            <div class="help-card glass-card rounded-2xl overflow-hidden shadow-sm" id="sec-billing">
                <button onclick="toggleAccordion('acc-4')" class="w-full flex items-center justify-between p-5 text-left bg-white/50 hover:bg-white/80 transition-colors">
                    <div class="flex items-center gap-3">
                        <span class="flex h-8 w-8 items-center justify-center rounded-lg bg-emerald-600 text-white font-bold text-xs">4</span>
                        <div>
                            <h2 class="text-sm font-black text-slate-900 uppercase tracking-wide">Billing & Thermal Receipt Generation</h2>
                            <p class="text-[11px] text-slate-500 font-medium">Calculating fees and printing receipts.</p>
                        </div>
                    </div>
                    <i id="icon-acc-4" class="fa-solid fa-chevron-down text-slate-400 transition-transform duration-300"></i>
                </button>
                
                <div id="acc-4" class="accordion-content">
                    <div class="p-6 border-t border-slate-200/60 bg-white/50 space-y-4 text-xs font-medium text-slate-700">
                        <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
                            <div class="space-y-3">
                                <p>Process billing at checkout:</p>
                                <ol class="list-decimal pl-5 space-y-1.5 text-slate-600">
                                    <li>Select appointment in the <strong>Billing Module</strong>.</li>
                                    <li>System calculates: <code>Total = Consultation + Treatment Fee</code>.</li>
                                    <li>Click <strong>Generate Receipt</strong> to print customer invoice.</li>
                                </ol>
                            </div>

                            <!-- Innovative JS Feature: Interactive Quick Fee Calculator -->
                            <div class="bg-emerald-50/70 p-4 rounded-2xl border border-emerald-200 space-y-3">
                                <span class="font-bold text-emerald-800 uppercase text-[10px] block flex items-center gap-1">
                                    <i class="fa-solid fa-calculator"></i> Staff Quick Fee Estimator
                                </span>
                                <div class="grid grid-cols-2 gap-2">
                                    <div>
                                        <label class="text-[10px] font-bold text-slate-500">Consultation (LKR)</label>
                                        <input type="number" id="calcConsult" value="1500" oninput="calculateEstimate()" class="w-full p-1.5 text-xs font-bold border rounded-lg">
                                    </div>
                                    <div>
                                        <label class="text-[10px] font-bold text-slate-500">Treatment Fee (LKR)</label>
                                        <input type="number" id="calcTreatment" value="3500" oninput="calculateEstimate()" class="w-full p-1.5 text-xs font-bold border rounded-lg">
                                    </div>
                                </div>
                                <div class="flex justify-between items-center pt-1 border-t border-emerald-200">
                                    <span class="text-xs font-bold text-slate-700">Estimated Total:</span>
                                    <span id="calcTotal" class="text-sm font-black text-emerald-700">LKR 5,000.00</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- Quick Desk Reference Summary -->
        <div class="glass-card rounded-3xl p-6 shadow-md border border-white">
            <h3 class="text-xs font-black text-slate-900 uppercase tracking-wider mb-4 flex items-center gap-2">
                <i class="fa-solid fa-keyboard text-indigo-600"></i> Staff Quick Desk Reference
            </h3>
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 text-center">
                <div class="p-3 bg-slate-100/80 rounded-xl border border-slate-200">
                    <span class="font-mono text-xs font-bold text-indigo-700 bg-white px-2 py-1 rounded shadow-sm border">10 Digits</span>
                    <p class="text-[10px] font-bold text-slate-500 uppercase mt-2">Contact Standard</p>
                </div>
                <div class="p-3 bg-slate-100/80 rounded-xl border border-slate-200">
                    <span class="font-mono text-xs font-bold text-indigo-700 bg-white px-2 py-1 rounded shadow-sm border">Unique ID</span>
                    <p class="text-[10px] font-bold text-slate-500 uppercase mt-2">Appointment Code</p>
                </div>
                <div class="p-3 bg-slate-100/80 rounded-xl border border-slate-200">
                    <span class="font-mono text-xs font-bold text-indigo-700 bg-white px-2 py-1 rounded shadow-sm border">Ctrl + P</span>
                    <p class="text-[10px] font-bold text-slate-500 uppercase mt-2">Quick Print</p>
                </div>
                <div class="p-3 bg-slate-100/80 rounded-xl border border-slate-200">
                    <span class="font-mono text-xs font-bold text-indigo-700 bg-white px-2 py-1 rounded shadow-sm border">LKR (Rs)</span>
                    <p class="text-[10px] font-bold text-slate-500 uppercase mt-2">Currency Standard</p>
                </div>
            </div>
        </div>

    </div>
</div>

<!-- Scripts for Dynamic Features -->
<script>
    // Accordion Logic
    function toggleAccordion(accId) {
        const content = document.getElementById(accId);
        const icon = document.getElementById('icon-' + accId);
        
        if (content.classList.contains('open')) {
            content.classList.remove('open');
            icon.style.transform = 'rotate(0deg)';
        } else {
            content.classList.add('open');
            icon.style.transform = 'rotate(180deg)';
        }
    }

    // Innovative Function 1: Expand/Collapse All
    function toggleAllAccordions(expand) {
        document.querySelectorAll('.accordion-content').forEach(el => {
            if (expand) {
                el.classList.add('open');
            } else {
                el.classList.remove('open');
            }
        });
        document.querySelectorAll('[id^="icon-acc-"]').forEach(icon => {
            icon.style.transform = expand ? 'rotate(180deg)' : 'rotate(0deg)';
        });
    }

    // Innovative Function 2: Real-time Search Filter with Dynamic Counter
    function filterHelpTopics() {
        const query = document.getElementById('helpSearch').value.toLowerCase();
        const cards = document.querySelectorAll('.help-card');
        let visibleCount = 0;

        cards.forEach(card => {
            const text = card.innerText.toLowerCase();
            if (text.includes(query)) {
                card.style.display = 'block';
                visibleCount++;
            } else {
                card.style.display = 'none';
            }
        });

        // Update indicator
        const badge = document.getElementById('searchResultCount');
        if (query.trim() === '') {
            badge.innerText = 'All Topics';
        } else {
            badge.innerText = visibleCount + ' Found';
        }
    }

    // Innovative Function 3: Quick Estimator Calculator
    function calculateEstimate() {
        const consult = parseFloat(document.getElementById('calcConsult').value) || 0;
        const treatment = parseFloat(document.getElementById('calcTreatment').value) || 0;
        const total = consult + treatment;
        document.getElementById('calcTotal').innerText = 'LKR ' + total.toLocaleString('en-US', { minimumFractionDigits: 2 });
    }

    // Open first accordion by default
    document.addEventListener('DOMContentLoaded', () => {
        toggleAccordion('acc-1');
        calculateEstimate();
    });
</script>

<jsp:include page="../components/footer.jsp" />