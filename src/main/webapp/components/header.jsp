<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Safely check session values to display context clues dynamically
    String currentUsername = (session != null && session.getAttribute("user") != null) ? (String) session.getAttribute("user") : "Guest User";
    String currentUserRole = (session != null && session.getAttribute("role") != null) ? (String) session.getAttribute("role") : "VISITOR";
%>
<!DOCTYPE html>
<html lang="en" class="h-full bg-slate-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sunrise Dental Care - Premium Portal</title>
    
    <!-- Tailwind CSS Engine CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- FontAwesome Vector Icon Library CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <script>
        // Custom branding configuration definitions
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        clinicPrimary: '#0f172a',    /* Sleek Deep Slate Blue */
                        clinicAccent: '#0284c7',     /* Electric Premium Cyan Teal */
                        clinicGold: '#f59e0b'        /* High-contrast Highlight Gold */
                    }
                }
            }
        }
        
        // Interactive Profile Menu Switcher Logics
        function toggleUserDropdown() {
            const dropdown = document.getElementById('userProfileDropdown');
            dropdown.classList.toggle('hidden');
        }
        
        // Close interactive popovers if a user clicks outside the element frame
        window.onclick = function(event) {
            if (!event.target.matches('.profile-drop-trigger') && !event.target.matches('.profile-drop-trigger *')) {
                const dropdown = document.getElementById('userProfileDropdown');
                if (dropdown && !dropdown.classList.contains('hidden')) {
                    dropdown.classList.add('hidden');
                }
            }
        }
    </script>
    <style type="text/css">
        /* Smooth transitions across interactive layout steps */
        .fade-in-smooth { animation: fadeIn 0.35s ease-out forwards; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body class="flex flex-col min-h-screen text-slate-800 antialiased font-sans">

    <!-- Responsive Navigation Topbar -->
    <header class="sticky top-0 z-40 w-full border-b border-slate-200 bg-white/80 backdrop-blur-md transition-all">
        <div class="mx-auto flex h-16 max-w-7xl items-center justify-between px-4 sm:px-6 lg:px-8">
            
            <!-- Brand Logotype Identity -->
            <div class="flex items-center gap-3">
                <div class="flex h-10 w-10 items-center justify-between justify-center rounded-xl bg-gradient-to-tr from-sky-600 to-indigo-700 text-white shadow-md shadow-sky-200">
                    <i class="fa-solid fa-tooth text-lg animate-pulse"></i>
                </div>
                <div>
                    <span class="text-lg font-extrabold tracking-tight text-slate-900">SUNRISE</span>
                    <span class="text-xs font-semibold tracking-wider text-sky-600 block -mt-1">DENTAL CARE</span>
                </div>
            </div>

            <!-- Contextual Operational Workspace Badge Info -->
            <div class="hidden md:flex items-center gap-2 rounded-full bg-slate-100 px-4 py-1.5 border border-slate-200">
                <span class="inline-block h-2 w-2 rounded-full bg-emerald-500 animate-ping"></span>
                <span class="text-xs font-bold text-slate-600 uppercase tracking-wide">
                    Live System Core Pipeline : <span class="text-sky-600"><%= currentUserRole %> Terminal</span>
                </span>
            </div>

            <!-- E-Commerce Inspired User Session Action Status Segment -->
            <div class="relative flex items-center gap-4">
                <button onclick="toggleUserDropdown()" class="profile-drop-trigger flex items-center gap-2 rounded-xl p-1.5 text-left transition-all hover:bg-slate-100 focus:outline-none focus:ring-2 focus:ring-sky-500">
                    <div class="flex h-9 w-9 items-center justify-center rounded-lg bg-slate-200 font-bold text-slate-700 border border-slate-300 shadow-inner">
                        <i class="fa-solid fa-user-shield text-sm text-sky-700"></i>
                    </div>
                    <div class="hidden sm:block">
                        <p class="text-xs font-bold leading-none text-slate-900"><%= currentUsername %></p>
                        <p class="mt-0.5 text-[10px] font-semibold text-slate-400 uppercase tracking-wider"><%= currentUserRole %></p>
                    </div>
                    <i class="fa-solid fa-chevron-down text-[10px] text-slate-400 ml-1 hidden sm:inline-block"></i>
                </button>

                <!-- Dropdown Menu Options -->
                <div id="userProfileDropdown" class="hidden absolute right-0 top-14 w-52 rounded-xl border border-slate-200 bg-white p-2 shadow-xl ring-1 ring-black/5 fade-in-smooth">
                    <div class="px-3 py-2 border-b border-slate-100 mb-1">
                        <p class="text-[10px] font-bold tracking-wider text-slate-400 uppercase">Account Status</p>
                        <p class="text-xs font-medium text-slate-600 truncate"><%= currentUsername %>@sunrisedental</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/AuthServlet?action=logout" class="flex w-full items-center gap-2 rounded-lg px-3 py-2 text-left text-xs font-bold text-rose-600 transition-colors hover:bg-rose-50">
                        <i class="fa-solid fa-power-off text-sm"></i>
                        <span>Secure Logout</span>
                    </a>
                </div>
            </div>
            
        </div>
    </header>

 </body>