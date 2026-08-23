<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.config.DatabaseConnection, java.sql.*" %>
<%
    // 1. Enforce rigorous security validation bounds first
    if(session.getAttribute("user") == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=Access Denied: Administrative Credentials Required");
        return;
    }
    
    // 2. Safe Null-Protected Session Variable Extractions
    Object idObj = session.getAttribute("userId");
    int sessionUserId = (idObj != null) ? (Integer) idObj : 0; 
    
    String sessionUsername = (String) session.getAttribute("user");
    String sessionRole = (String) session.getAttribute("role");
%>
<jsp:include page="../components/header.jsp" />
<!-- Injection for Popups using SweetAlert2 Distribution Matrix via CDN -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
    .glass-hud-panel {
        background: rgba(224, 242, 254, 0.75);
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.5);
        box-shadow: 0 8px 32px 0 rgba(15, 23, 42, 0.08);
    }
    .glass-matrix-card {
        background: rgba(255, 255, 255, 0.85);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.6);
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .glass-matrix-card:hover {
        background: rgba(240, 249, 255, 0.95);
        transform: translateY(-2px);
        border-color: rgba(14, 165, 233, 0.3);
    }
</style>

<div class="relative min-h-[85vh] rounded-3xl overflow-hidden p-4 sm:p-6 lg:p-10 border border-slate-200/60 shadow-xl bg-cover bg-center transition-all duration-700"
     style="background-image: url('https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=1920&q=80');">
    
    <div class="absolute inset-0 z-0 bg-gradient-to-tr from-slate-950/85 via-slate-900/40 to-indigo-950/20"></div>

    <div class="relative z-10 max-w-4xl mx-auto space-y-6">

        <!-- Header Module -->
        <div class="glass-hud-panel rounded-2xl border border-white/40 p-5 sm:p-6 shadow-lg shadow-slate-900/10">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                <div>
                    <div class="flex items-center gap-2">
                        <span class="inline-flex h-6 w-6 items-center justify-center rounded-md bg-indigo-600 text-white shadow-sm">
                            <i class="fa-solid fa-users-gear text-[11px]"></i>
                        </span>
                        <h1 class="text-xl font-black tracking-tight text-slate-900 uppercase sm:text-2xl">Staff System Control Matrix</h1>
                    </div>
                    <p class="mt-1 text-xs sm:text-sm font-medium text-slate-500">Audit system user profiles, manage staff nodes, and alter identity parameters dynamically.</p>
                </div>
                <a href="dashboard.jsp" class="inline-flex items-center gap-2 self-start md:self-center rounded-xl border border-slate-200 bg-white/90 px-4 py-2 text-xs font-bold text-slate-700 shadow-sm transition-all hover:bg-slate-50 hover:text-slate-900 active:scale-[0.98] backdrop-blur-sm">
                    <i class="fa-solid fa-arrow-left-long text-slate-500"></i>
                    <span>Control Hub</span>
                </a>
            </div>
        </div>

        <!-- SPLIT INTERFACE PANEL GRID: Self Update Form vs Add New Node Form -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            
            <!-- SUB-SECTION A: Edit Self Identity Parameter Matrix -->
            <div class="glass-matrix-card rounded-2xl border border-white/40 p-5 shadow-md flex flex-col justify-between">
                <div>
                    <h3 class="text-xs font-black text-slate-700 tracking-wider uppercase mb-3 flex items-center gap-2">
                        <i class="fa-solid fa-user-pen text-amber-600"></i>
                        Modify Your Identity Configuration
                    </h3>
                    <p class="text-[11px] text-slate-500 mb-4">Alter your personal operational key traits directly inside the database user records.</p>
                </div>
                <form action="../StaffManagementServlet" method="post" class="space-y-3">
                    <input type="hidden" name="actionType" value="UPDATE" />
                    <input type="hidden" name="userId" value="<%= sessionUserId %>" />
                    
                    <div class="space-y-1">
                        <label class="text-[10px] uppercase font-black tracking-wide text-slate-400 block pl-1">Your Username</label>
                        <input type="text" name="username" required value="<%= sessionUsername %>" 
                               class="w-full rounded-xl border border-slate-200 bg-slate-50/60 py-2 px-3 text-xs font-bold text-slate-700 focus:border-indigo-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500 transition-all shadow-inner" />
                    </div>
                    <div class="space-y-1">
                        <label class="text-[10px] uppercase font-black tracking-wide text-slate-400 block pl-1">New Secure Password</label>
                        <input type="password" name="password" required placeholder="Re-enter or create passkey" 
                               class="w-full rounded-xl border border-slate-200 bg-slate-50/60 py-2 px-3 text-xs font-bold text-slate-700 focus:border-indigo-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500 transition-all shadow-inner" />
                    </div>
                    <div class="space-y-1">
                        <label class="text-[10px] uppercase font-black tracking-wide text-slate-400 block pl-1">Access Role Level Clearance</label>
                        <select name="role" class="w-full rounded-xl border border-slate-200 bg-slate-50/60 py-2 px-3 text-xs font-bold text-slate-700 focus:ring-1 focus:ring-indigo-500 transition-all cursor-pointer">
                            <option value="ADMIN" <%= "ADMIN".equals(sessionRole) ? "selected" : "" %>>ADMINISTRATOR</option>
                            <option value="RECEPTIONIST" <%= "RECEPTIONIST".equals(sessionRole) ? "selected" : "" %>>RECEPTIONIST</option>
                            <option value="DENTIST" <%= "DENTIST".equals(sessionRole) ? "selected" : "" %>>DENTIST</option>
                        </select>
                    </div>
                    <button type="submit" class="w-full inline-flex items-center justify-center gap-2 rounded-xl bg-amber-600 hover:bg-amber-500 text-white font-black tracking-wide uppercase text-[10px] py-2.5 transition-all shadow-sm active:scale-[0.98]">
                        <i class="fa-solid fa-floppy-disk text-[11px]"></i>
                        <span>Save Profile Data</span>
                    </button>
                </form>
            </div>

            <!-- SUB-SECTION B: Insert New Staff Credentials Section Matrix -->
            <div class="glass-matrix-card rounded-2xl border border-white/40 p-5 shadow-md flex flex-col justify-between">
                <div>
                    <h3 class="text-xs font-black text-slate-700 tracking-wider uppercase mb-3 flex items-center gap-2">
                        <i class="fa-solid fa-user-plus text-indigo-600"></i>
                        Provision New Account Node
                    </h3>
                    <p class="text-[11px] text-slate-500 mb-4">Generate completely new system credential authorization keys into active storage logs.</p>
                </div>
                <form action="../StaffManagementServlet" method="post" class="space-y-3">
                    <input type="hidden" name="actionType" value="INSERT" />
                    
                    <div class="space-y-1">
                        <label class="text-[10px] uppercase font-black tracking-wide text-slate-400 block pl-1">Sign Username</label>
                        <input type="text" name="username" required placeholder="e.g. receptionist_j" 
                               class="w-full rounded-xl border border-slate-200 bg-slate-50/60 py-2 px-3 text-xs font-bold text-slate-700 focus:border-indigo-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500 transition-all shadow-inner" />
                    </div>
                    <div class="space-y-1">
                        <label class="text-[10px] uppercase font-black tracking-wide text-slate-400 block pl-1">Passkey Credential</label>
                        <input type="password" name="password" required placeholder="••••••••" 
                               class="w-full rounded-xl border border-slate-200 bg-slate-50/60 py-2 px-3 text-xs font-bold text-slate-700 focus:border-indigo-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500 transition-all shadow-inner" />
                    </div>
                    <div class="space-y-1">
                        <label class="text-[10px] uppercase font-black tracking-wide text-slate-400 block pl-1">Security Domain Profile</label>
                        <select name="role" class="w-full rounded-xl border border-slate-200 bg-slate-50/60 py-2 px-3 text-xs font-bold text-slate-700 focus:ring-1 focus:ring-indigo-500 transition-all cursor-pointer">
                            <option value="RECEPTIONIST">RECEPTIONIST</option>
                            <option value="DENTIST">DENTIST</option>
                            <option value="ADMIN">ADMINISTRATOR</option>
                        </select>
                    </div>
                    <button type="submit" class="w-full inline-flex items-center justify-center gap-2 rounded-xl bg-slate-900 hover:bg-slate-800 text-white font-black tracking-wide uppercase text-[10px] py-2.5 transition-all shadow-sm active:scale-[0.98]">
                        <i class="fa-solid fa-plus-circle text-[11px]"></i>
                        <span>Commit Registry</span>
                    </button>
                </form>
            </div>
        </div>

        <!-- Search Filtering Utilities -->
        <div class="flex flex-col sm:flex-row items-center justify-between gap-4 rounded-2xl border border-white/40 bg-white/85 p-4 shadow-md backdrop-blur-md">
            <div class="relative w-full sm:max-w-xs group">
                <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400">
                    <i class="fa-solid fa-magnifying-glass text-xs"></i>
                </span>
                <input type="text" id="staffSearch" onkeyup="filterStaffTable()" placeholder="Filter profiles by signature username..." 
                       class="w-full rounded-xl border border-slate-200 bg-slate-50/60 py-2.5 pl-10 pr-4 text-xs font-bold text-slate-700 placeholder-slate-400 focus:outline-none focus:ring-1 focus:ring-indigo-500 transition-all shadow-inner" />
            </div>
            <div class="flex items-center gap-2 self-stretch sm:self-auto justify-center rounded-xl bg-indigo-600/90 px-4 py-2.5 text-xs font-bold text-white shadow-sm">
                <i class="fa-solid fa-user-shield text-[11px] text-indigo-200"></i>
                <span>Active Node Scope: <span id="staffCounter" class="text-white font-black px-1.5 py-0.5 bg-white/20 rounded-md font-mono">0</span> Users</span>
            </div>
        </div>

        <!-- Data Grid Table -->
        <div class="overflow-hidden rounded-2xl border border-white/50 bg-white/90 shadow-xl backdrop-blur-md">
            <div class="overflow-x-auto">
                <table class="w-full border-collapse text-left text-xs text-slate-600">
                    <thead>
                        <tr class="border-b border-slate-200 bg-slate-100/60 font-black uppercase tracking-wider text-slate-400 text-[10px]">
                            <th scope="col" class="px-6 py-4">Account ID</th>
                            <th scope="col" class="px-6 py-4">Username Signature</th>
                            <th scope="col" class="px-6 py-4">Assigned Security Clearance</th>
                            <th scope="col" class="px-6 py-4 text-center">System Actions</th>
                        </tr>
                    </thead>
                    <tbody id="staffTableBody" class="divide-y divide-slate-100 font-medium">
                    <%
                        int recordCounter = 0;
                        try {
                            Connection conn = DatabaseConnection.getInstance().getConnection();
                            String sql = "SELECT id, username, role FROM users ORDER BY id ASC";
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery(sql);
                            
                            while(rs.next()) {
                                recordCounter++;
                                String role = rs.getString("role");
                                int userId = rs.getInt("id");
                    %>
                        <tr class="staff-row transition-all duration-200 hover:bg-indigo-50/40 group">
                            <td class="whitespace-nowrap px-6 py-4 font-bold text-slate-400">
                                <span class="inline-flex items-center gap-1.5 rounded-md bg-slate-100 px-2.5 py-1 text-[11px] font-mono text-slate-700 border border-slate-200">
                                    <i class="fa-solid fa-hashtag text-[9px] text-slate-400"></i><%= userId %>
                                </span>
                            </td>
                            <td class="whitespace-nowrap px-6 py-4 text-sm font-bold text-slate-800">
                                <div class="flex items-center gap-3">
                                    <div class="flex h-8 w-8 items-center justify-center rounded-xl bg-gradient-to-br from-slate-100 to-slate-200 border text-[11px] text-slate-600 font-black tracking-wider transition-all group-hover:from-indigo-600 group-hover:to-blue-600 group-hover:text-white">
                                        <%= rs.getString("username").substring(0, Math.min(rs.getString("username").length(), 2)).toUpperCase() %>
                                    </div>
                                    <span class="searchable-name tracking-wide text-slate-900"><%=(userId == sessionUserId) ? rs.getString("username") + " (You)" : rs.getString("username")%></span>
                                </div>
                            </td>
                            <td class="whitespace-nowrap px-6 py-4">
                                <% if("ADMIN".equals(role)) { %>
                                    <span class="inline-flex items-center gap-1.5 rounded-full bg-blue-50 px-3 py-1 text-[10px] font-black text-blue-700 border border-blue-200 tracking-wider uppercase shadow-sm">
                                        <i class="fa-solid fa-shield-halved text-[9px]"></i>ADMIN
                                    </span>
                                <% } else if("DENTIST".equals(role)) { %>
                                    <span class="inline-flex items-center gap-1.5 rounded-full bg-sky-50 px-3 py-1 text-[10px] font-black text-sky-700 border border-sky-200 tracking-wider uppercase shadow-sm">
                                        <i class="fa-solid fa-user-doctor text-[9px]"></i>DENTIST
                                    </span>
                                <% } else { %>
                                    <span class="inline-flex items-center gap-1.5 rounded-full bg-emerald-50 px-3 py-1 text-[10px] font-black text-emerald-700 border border-emerald-200 tracking-wider uppercase shadow-sm">
                                        <i class="fa-solid fa-user-pen text-[9px]"></i>RECEPTIONIST
                                    </span>
                                <% } %>
                            </td>
                            <td class="whitespace-nowrap px-6 py-4 text-center">
                                <% if(userId != sessionUserId) { %>
                                    <button type="button" onclick="confirmDeletion('<%= userId %>')" class="inline-flex h-7 w-7 items-center justify-center rounded-lg bg-slate-100 border border-slate-200 hover:bg-rose-600 hover:text-white text-slate-400 transition-all active:scale-[0.93]">
                                        <i class="fa-solid fa-trash-can text-[10px]"></i>
                                    </button>
                                    <!-- Hidden utility mapping forms to process safe postbacks via unique JavaScript calls -->
                                    <form id="delete-form-<%= userId %>" action="../StaffManagementServlet" method="post" style="display:none;">
                                        <input type="hidden" name="actionType" value="DELETE" />
                                        <input type="hidden" name="userId" value="<%= userId %>" />
                                    </form>
                                <% } else { %>
                                    <span class="text-[10px] font-black tracking-wide text-slate-400 uppercase italic">Locked Node</span>
                                <% } %>
                            </td>
                        </tr>
                    <%
                            }
                            rs.close();
                            stmt.close();
                        } catch (Exception e) {
                    %>
                        <tr>
                            <td colspan="4" class="px-6 py-12 text-center text-sm font-bold text-rose-600 bg-rose-50/20">Critical database structure fault: <%= e.getMessage() %></td>
                        </tr>
                    <% } %>
                        <tr id="emptyStateRow" class="hidden">
                            <td colspan="4" class="px-6 py-12 text-center text-sm font-semibold text-slate-400 bg-slate-50/20">No matching profile identities discovered.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

<script>
    // POPUP MECHANICS ENGINE (SweetAlert2 Interceptor Mapping)
    document.addEventListener("DOMContentLoaded", () => {
        document.getElementById('staffCounter').textContent = "<%= recordCounter %>";
        
        // Extract parameters parsing URLs directly inside client browser
        const urlParams = new URLSearchParams(window.location.search);
        const msg = urlParams.get('msg');
        const error = urlParams.get('error');

        if (msg) {
            Swal.fire({
                title: 'Operation Committed!',
                text: msg,
                icon: 'success',
                confirmButtonColor: '#0f172a',
                customClass: { popup: 'rounded-2xl font-sans' }
            });
        }

        if (error) {
            Swal.fire({
                title: 'Transaction Aborted',
                text: error,
                icon: 'error',
                confirmButtonColor: '#e11d48',
                customClass: { popup: 'rounded-2xl font-sans' }
            });
        }
    });

    function confirmDeletion(userId) {
        Swal.fire({
            title: 'Revoke Credentials?',
            text: "This action immediately purges this authorization profile node from active tables!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#e11d48',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Yes, unlink account!',
            customClass: { popup: 'rounded-2xl font-sans' }
        }).then((result) => {
            if (result.isConfirmed) {
                document.getElementById('delete-form-' + userId).submit();
            }
        });
    }

    function filterStaffTable() {
        const queryInput = document.getElementById('staffSearch').value.trim().toLowerCase();
        const rows = document.querySelectorAll('.staff-row');
        let visibleCount = 0;
        
        rows.forEach(row => {
            const signatureElement = row.querySelector('.searchable-name');
            if (signatureElement) {
                const targetText = signatureElement.textContent.toLowerCase();
                if (targetText.includes(queryInput)) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            }
        });
        
        document.getElementById('staffCounter').textContent = visibleCount;
        document.getElementById('emptyStateRow').classList.toggle('hidden', visibleCount > 0);
    }
</script>

<jsp:include page="../components/footer.jsp" />