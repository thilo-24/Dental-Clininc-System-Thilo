<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.config.DatabaseConnection, java.sql.*" %>
<%
    if(session.getAttribute("user") == null || !"RECEPTIONIST".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=Access Denied: Administrative Credentials Required");
        return;
    }
%>
<jsp:include page="../components/header.jsp" />

<!-- Advanced Design Token Underlays for Glassmorphic Front-Desk Terminal Architecture -->
<style>
    .glass-search-hud {
       background: rgba(224, 242, 254, 0.75); /* Soft sky-blue undertone */
        backdrop-filter: blur(16px);
        -webkit-backdrop-filter: blur(16px);
        border: 1px solid rgba(255, 255, 255, 0.5);
        box-shadow: 0 8px 32px 0 rgba(15, 23, 42, 0.08);
    }
    .glass-ledger-card {
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
    
    <!-- Precise Color Masking Layer to Stabilize Data Grid Contrast Vectors -->
    <div class="absolute inset-0 z-0 bg-gradient-to-tr from-slate-950/85 via-slate-900/40 to-indigo-950/20"></div>

    <div class="relative z-10 max-w-4xl mx-auto space-y-6">

        <!-- Front-Desk Search Workspace Header & Navigation Block -->
        <div class="glass-search-hud rounded-2xl border border-white/40 p-5 sm:p-6 shadow-lg shadow-slate-900/10">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                <div>
                    <div class="flex items-center gap-2">
                        <span class="inline-flex h-6 w-6 items-center justify-center rounded-md bg-indigo-600 text-white shadow-sm shadow-indigo-600/20">
                            <i class="fa-solid fa-database text-[11px]"></i>
                        </span>
                        <h1 class="text-xl font-black tracking-tight text-slate-900 uppercase sm:text-2xl">Master Records Engine</h1>
                    </div>
                    <p class="mt-1 text-xs sm:text-sm font-medium text-slate-500">Query the central database core to retrieve clinical patient logs and verified system indices.</p>
                </div>
                
                <!-- Navigation Return Anchor -->
                <a href="dashboard.jsp" class="inline-flex items-center gap-2 self-start md:self-center rounded-xl border border-slate-200 bg-white/90 px-4 py-2 text-xs font-bold text-slate-700 shadow-sm transition-all hover:bg-slate-50 hover:text-slate-900 active:scale-[0.98] backdrop-blur-sm">
                    <i class="fa-solid fa-arrow-left-long text-slate-400"></i>
                    <span>Dashboard View</span>
                </a>
            </div>
        </div>

        <%
            String query = request.getParameter("searchQuery");
            String cleanQuery = (query != null) ? query.trim() : "";
        %>

        <!-- Search Form Input Container Matrix -->
        <form method="get" onsubmit="triggerSearchState(this)" class="glass-search-hud flex flex-col sm:flex-row items-center gap-3 rounded-2xl border border-white/40 p-4 shadow-md group">
            <div class="relative w-full flex-grow">
                <span class="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400 group-focus-within:text-indigo-500 transition-colors">
                    <i class="fa-solid fa-magnifying-glass text-xs"></i>
                </span>
                <input type="text" name="searchQuery" value="<%= cleanQuery %>" placeholder="Search by patient profile name..." 
                       class="w-full rounded-xl border border-slate-200/80 bg-slate-50/60 py-2.5 pl-10 pr-4 text-xs font-bold text-slate-700 placeholder-slate-400 focus:border-indigo-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500 transition-all shadow-inner" />
            </div>
            
            <button type="submit" id="searchSubmitBtn" 
                    class="w-full sm:w-auto inline-flex items-center justify-center gap-2 rounded-xl bg-slate-900 px-6 py-2.5 text-xs font-black tracking-wide uppercase text-white shadow-sm transition-all hover:bg-slate-800 active:scale-[0.98] focus:outline-none whitespace-nowrap">
                <i class="fa-solid fa-filter text-[10px]"></i>
                <span>Execute Search</span>
            </button>
        </form>

        <!-- Patient Records Data Ledger Card -->
        <div class="glass-ledger-card overflow-hidden rounded-2xl border border-white/50 shadow-2xl flex flex-col justify-between min-h-[400px]">
            <div>
                <div class="p-4 border-b border-slate-200 bg-slate-100/60 flex items-center justify-between">
                    <h3 class="text-[10px] font-black text-slate-400 tracking-wider uppercase flex items-center gap-2">
                        <i class="fa-solid fa-layer-group text-indigo-600"></i>
                        Database Retrieval Matrix
                    </h3>
                    <% if (!cleanQuery.isEmpty()) { %>
                        <span class="inline-flex items-center rounded-md bg-indigo-50/90 px-2 py-1 text-[10px] font-bold text-indigo-700 border border-indigo-100/80 shadow-sm backdrop-blur-sm">
                            Filter: "<%= cleanQuery %>"
                        </span>
                    <% } %>
                </div>
                
                <div class="overflow-x-auto">
                    <table class="w-full border-collapse text-left text-xs text-slate-600">
                        <thead>
                            <tr class="border-b border-slate-200 bg-slate-100/30 font-black uppercase tracking-wider text-slate-400 text-[10px]">
                                <th scope="col" class="px-6 py-4.5">Patient ID</th>
                                <th scope="col" class="px-6 py-4.5">Name Profile</th>
                                <th scope="col" class="px-6 py-4.5">Contact Details</th>
                                <th scope="col" class="px-6 py-4.5">Registration Date</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100 font-medium">
                        <%
                            try {
                                Connection conn = DatabaseConnection.getInstance().getConnection();
                                String sql = "SELECT * FROM patients";
                                if (!cleanQuery.isEmpty()) {
                                    sql += " WHERE name LIKE ? ORDER BY name ASC";
                                } else {
                                    sql += " ORDER BY id DESC";
                                }
                                
                                PreparedStatement ps = conn.prepareStatement(sql);
                                if (!cleanQuery.isEmpty()) {
                                    ps.setString(1, "%" + cleanQuery + "%");
                                }
                                
                                ResultSet rs = ps.executeQuery();
                                boolean hasResults = false;
                                
                                while(rs.next()) {
                                    hasResults = true;
                        %>
                            <tr class="transition-all duration-200 hover:bg-indigo-50/40 group">
                                <!-- Patient ID Code Node -->
                                <td class="whitespace-nowrap px-6 py-4 font-bold text-slate-900">
                                    <span class="inline-flex items-center gap-1 rounded-lg bg-slate-100 border border-slate-300/60 px-2 py-1 text-[11px] font-mono font-bold text-slate-700 shadow-inner group-hover:bg-white group-hover:border-slate-400/60 transition-colors">
                                        #<%= rs.getInt("id") %>
                                    </span>
                                </td>
                                
                                <!-- Profile Identity -->
                                <td class="whitespace-nowrap px-6 py-4 text-sm font-black text-slate-900 group-hover:text-indigo-950 transition-colors">
                                    <%= rs.getString("name") %>
                                </td>
                                
                                <!-- Contact Reference -->
                                <td class="whitespace-nowrap px-6 py-4 font-mono text-slate-700">
                                    <div class="flex items-center gap-2">
                                        <div class="flex h-6 w-6 items-center justify-center rounded-md bg-slate-100 text-[10px] text-slate-500 border border-slate-200 group-hover:bg-indigo-600 group-hover:text-white group-hover:border-transparent shadow-sm transition-all duration-300">
                                            <i class="fa-solid fa-phone"></i>
                                        </div>
                                        <span class="font-bold"><%= rs.getString("contact_number") %></span>
                                    </div>
                                </td>
                                
                                <!-- Timestamp Entry -->
                                <td class="whitespace-nowrap px-6 py-4 text-slate-500 text-[11px]">
                                    <div class="flex items-center gap-1.5 font-semibold text-slate-600">
                                        <i class="fa-regular fa-calendar-days text-[10px] text-slate-400"></i>
                                        <span><%= rs.getTimestamp("registration_date") %></span>
                                    </div>
                                </td>
                            </tr>
                        <%
                                }
                                if (!hasResults) {
                        %>
                            <tr>
                                <td colspan="4" class="px-6 py-16 text-center text-sm font-bold text-slate-400 bg-slate-50/30">
                                    <div class="flex flex-col items-center justify-center gap-3">
                                        <div class="h-12 w-12 rounded-full bg-slate-100 flex items-center justify-center border border-slate-200 text-slate-400 shadow-inner">
                                            <i class="fa-solid fa-user-slash text-xl"></i>
                                        </div>
                                        <span class="tracking-wide text-xs uppercase font-black text-slate-400">No matching customer files discovered in current workspace parameters.</span>
                                    </div>
                                </td>
                            </tr>
                        <%
                                }
                                rs.close();
                                ps.close();
                            } catch (Exception e) {
                        %>
                            <tr>
                                <td colspan="4" class="px-6 py-12 text-center text-xs font-bold text-rose-600 bg-rose-50/40">
                                    <div class="flex flex-col items-center justify-center gap-2">
                                        <i class="fa-solid fa-circle-nodes text-xl animate-bounce"></i>
                                        <span>System data recovery error. Exception matching pool connection context.</span>
                                    </div>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Terminal Balance Info Alert Banner Footer -->
            <div class="p-4 bg-indigo-50/80 border-t border-indigo-200/60 flex gap-3 items-start mt-auto backdrop-blur-sm">
                <i class="fa-solid fa-shield-halved text-indigo-600 text-sm mt-0.5"></i>
                <p class="text-[11px] font-semibold leading-relaxed text-indigo-900">
                    <strong class="font-bold">Access Integrity Notice:</strong> All search queries executed are tracked via internal administrative access keys. Ensure parameters align with the hospital information storage policy before inspecting systemic health log entries.
                </p>
            </div>
        </div>

    </div>
</div>

<!-- Form Processing Animation Handler Script -->
<script>
    function triggerSearchState(formElement) {
        const btn = document.getElementById('searchSubmitBtn');
        if(btn) {
            btn.disabled = true;
            btn.classList.remove('bg-slate-900', 'hover:bg-slate-800');
            btn.classList.add('bg-slate-400', 'cursor-not-allowed', 'text-slate-200');
            btn.innerHTML = `<i class="fa-solid fa-circle-notch animate-spin text-[10px]"></i> <span>Searching Database...</span>`;
        }
    }
</script>

<jsp:include page="../components/footer.jsp" />