<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" class="h-full bg-slate-900">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sunrise Dental Clinic - Secure Access Login</title>
    <!-- Tailwind CSS Engine -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome Icon Library -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="h-full flex items-center justify-center relative overflow-hidden font-sans bg-slate-950">

		<!-- High-Visibility Random Background Video Layer -->
		<div class="fixed inset-0 z-0 overflow-hidden pointer-events-none">
		    <video id="bgVideo" autoplay muted playsinline 
		           class="absolute top-1/2 left-1/2 min-w-full min-h-full w-auto h-auto -translate-x-1/2 -translate-y-1/2 object-cover filter brightness-100 contrast-105 transition-opacity duration-1000">
		        <source id="videoSource" src="" type="video/mp4">
		        Your browser does not support HTML5 video.
		    </video>
		
		    <!-- Lighter Overlay: Protects text readability while letting the video shine through clearly -->
		    <div class="absolute inset-0 bg-gradient-to-br from-slate-950/40 via-slate-900/30 to-indigo-950/30"></div>
		</div>

    <!-- Main Glassmorphic Core Container Card -->
    <div class="relative z-20 w-full max-w-md mx-4 sm:mx-0 bg-white/95 border border-white/20 rounded-2xl shadow-2xl overflow-hidden transition-all duration-300 hover:shadow-indigo-500/10">
        
        <!-- Top Medical Clinic Color Identity Strip -->
        <div class="h-1.5 bg-gradient-to-r from-blue-500 via-indigo-500 to-cyan-500"></div>

        <div class="p-8 sm:p-10">
            <!-- Branding Header Block -->
            <div class="text-center mb-8">
                <div class="inline-flex h-12 w-12 items-center justify-center rounded-xl bg-gradient-to-br from-blue-500 to-indigo-600 text-white shadow-md shadow-indigo-500/20 mb-3">
                    <i class="fa-solid fa-tooth text-xl animate-pulse"></i>
                </div>
                <h1 class="text-xl font-extrabold tracking-tight text-slate-900 uppercase sm:text-2xl">Sunrise Dental Clinic</h1>
                <p class="mt-1.5 text-xs font-semibold text-slate-400 tracking-wider uppercase">Information Management System</p>
            </div>
            
            <!-- Error System Warning Banner Handling Framework -->
            <% if(request.getParameter("error") != null) { %>
                <div id="errorPanel" class="mb-6 flex items-start gap-3 rounded-xl bg-rose-50 border border-rose-200 p-3.5 text-rose-800 shadow-sm transition-all duration-300 animate-shake">
                    <i class="fa-solid fa-circle-exclamation text-sm mt-0.5 shrink-0 text-rose-500"></i>
                    <div class="flex-grow">
                        <p class="text-xs font-bold leading-normal"><%= request.getParameter("error") %></p>
                    </div>
                    <button onclick="dismissError()" type="button" class="rounded-lg p-0.5 text-rose-400 hover:bg-rose-100 transition-colors">
                        <i class="fa-solid fa-xmark text-xs"></i>
                    </button>
                </div>
            <% } %>

            <!-- Interactive Router Form Module -->
            <form action="${pageContext.request.contextPath}/AuthServlet" method="post" onsubmit="lockAuthButton(this)" class="space-y-5">
                
                <!-- System Username Box Field -->
                <div>
                    <label class="block text-[11px] font-bold tracking-wider text-slate-500 mb-2 uppercase">System Username</label>
                    <div class="relative group">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400 group-focus-within:text-blue-500 transition-colors">
                            <i class="fa-solid fa-user-shield text-xs"></i>
                        </span>
                        <input type="text" name="username" required autocomplete="off" placeholder="Enter security id"
                               class="w-full rounded-xl border border-slate-200 bg-slate-50/50 py-3 pl-10 pr-4 text-xs font-bold text-slate-800 placeholder-slate-400 focus:border-blue-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-blue-500 transition-all shadow-inner">
                    </div>
                </div>

                <!-- Security Password Box Field -->
                <div>
                    <label class="block text-[11px] font-bold tracking-wider text-slate-500 mb-2 uppercase">Security Password</label>
                    <div class="relative group">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400 group-focus-within:text-blue-500 transition-colors">
                            <i class="fa-solid fa-key text-xs"></i>
                        </span>
                        <input type="password" name="password" id="passwordField" required placeholder="••••••••"
                               class="w-full rounded-xl border border-slate-200 bg-slate-50/50 py-3 pl-10 pr-10 text-xs font-bold text-slate-800 placeholder-slate-400 focus:border-blue-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-blue-500 transition-all shadow-inner">
                        <button type="button" onclick="togglePasswordVisibility()" class="absolute inset-y-0 right-0 flex items-center pr-3.5 text-slate-400 hover:text-slate-600 transition-colors">
                            <i id="toggleIcon" class="fa-solid fa-eye text-xs"></i>
                        </button>
                    </div>
                </div>

                <!-- Submission Commit Action Button -->
                <div class="pt-2">
                    <button type="submit" id="authSubmitBtn" 
                            class="w-full inline-flex items-center justify-center gap-2 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-600 px-5 py-3.5 text-xs font-bold text-white shadow-md shadow-indigo-600/10 transition-all hover:from-blue-500 hover:to-indigo-500 hover:shadow-lg active:scale-[0.99] focus:outline-none tracking-wider uppercase">
                        <i class="fa-solid fa-unlock-keyhole text-xs"></i>
                        <span>Authenticate Account</span>
                    </button>
                </div>
            </form>
        </div>
        
        <!-- System Footer Context Reference -->
        <div class="bg-slate-50 border-t border-slate-100 px-8 py-4 text-center">
            <span class="text-[10px] font-bold text-slate-400 tracking-wider uppercase">
                <i class="fa-solid fa-shield-halved text-emerald-500 mr-1"></i> Encrypted Session Environment
            </span>
        </div>
    </div>

    <!-- Core Interface Mechanics Script Layer -->
    <script>
        // Array of 5 Background Video File Paths
        const videoPlaylist = [
            "${pageContext.request.contextPath}/assets/videos/bg1.mp4",
            "${pageContext.request.contextPath}/assets/videos/bg2.mp4",
            "${pageContext.request.contextPath}/assets/videos/bg3.mp4",
            "${pageContext.request.contextPath}/assets/videos/bg4.mp4",
            "${pageContext.request.contextPath}/assets/videos/bg5.mp4"
        ];

        let currentVideoIndex = -1;

        function playRandomVideo() {
            const videoElement = document.getElementById('bgVideo');
            const sourceElement = document.getElementById('videoSource');

            // Pick a random video that is different from the currently playing one
            let newIndex;
            do {
                newIndex = Math.floor(Math.random() * videoPlaylist.length);
            } while (newIndex === currentVideoIndex && videoPlaylist.length > 1);

            currentVideoIndex = newIndex;

            // Load and Play
            sourceElement.src = videoPlaylist[currentVideoIndex];
            videoElement.load();
            videoElement.play().catch(err => {
                console.log("Autoplay blocked or waiting for user interaction:", err);
            });
        }

        // Initialize playlist when page loads
        document.addEventListener("DOMContentLoaded", () => {
            const videoElement = document.getElementById('bgVideo');
            
            // Play first random video
            playRandomVideo();

            // When current video finishes, automatically play another random video
            videoElement.addEventListener('ended', () => {
                playRandomVideo();
            });
        });

        // Smooth dismiss animation framework for warnings
        function dismissError() {
            const panel = document.getElementById('errorPanel');
            if(panel) {
                panel.style.opacity = '0';
                setTimeout(() => panel.remove(), 250);
            }
        }

        // Inline configuration for password toggle visualization logic
        function togglePasswordVisibility() {
            const field = document.getElementById('passwordField');
            const icon = document.getElementById('toggleIcon');
            if(field.type === 'password') {
                field.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                field.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        // Anti-Spam Lockout: Mutate interactive submission tools during ongoing transaction pipelines
        function lockAuthButton(formElement) {
            const btn = document.getElementById('authSubmitBtn');
            if(btn) {
                btn.disabled = true;
                btn.className = "w-full inline-flex items-center justify-center gap-2 rounded-xl bg-slate-400 px-5 py-3.5 text-xs font-bold text-white cursor-not-allowed tracking-wider uppercase";
                btn.innerHTML = `<i class="fa-solid fa-circle-notch animate-spin text-xs"></i> <span>Verifying System Credentials...</span>`;
            }
        }
    </script>
</body>
</html>