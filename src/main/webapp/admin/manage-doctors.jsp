<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.config.DatabaseConnection, java.sql.*, java.util.*" %>
<%
    // Security Guard: Admin Session Verification
    if(session.getAttribute("user") == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=Access Denied: Administrative Session Required");
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
    
    <div class="absolute inset-0 z-0 bg-gradient-to-tr from-slate-950/85 via-slate-900/40 to-indigo-950/20"></div>

    <div class="relative z-10 max-w-6xl mx-auto space-y-6">

        <!-- Header Bar -->
        <div class="glass-hud rounded-2xl border border-white/40 p-5 sm:p-6 shadow-lg">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                <div>
                    <div class="flex items-center gap-2">
                        <span class="inline-flex h-7 w-7 items-center justify-center rounded-lg bg-teal-600 text-white shadow-sm">
                            <i class="fa-solid fa-user-doctor text-xs"></i>
                        </span>
                        <h1 class="text-xl font-black tracking-tight text-slate-900 uppercase sm:text-2xl">Doctor Directory and Capabilities</h1>
                    </div>
                    <p class="mt-1 text-xs sm:text-sm font-medium text-slate-500">Register dental surgeons, toggle active channel availability, and authorize treatment capabilities.</p>
                </div>
                
                <a href="dashboard.jsp" class="inline-flex items-center gap-2 self-start md:self-center rounded-xl border border-slate-200 bg-white/90 px-4 py-2 text-xs font-bold text-slate-700 shadow-sm transition-all hover:bg-slate-50">
                    <i class="fa-solid fa-arrow-left-long text-slate-400"></i>
                    <span>Dashboard View</span>
                </a>
            </div>
        </div>

        <!-- Action Response Notifications -->
        <% if(request.getParameter("msg") != null) { %>
            <div id="statusToast" class="flex items-center justify-between rounded-xl bg-emerald-500/95 border border-emerald-400/40 p-4 text-white shadow-lg backdrop-blur-md transition-all">
                <div class="flex items-center gap-3">
                    <i class="fa-solid fa-circle-check text-base"></i>
                    <p class="text-xs font-bold tracking-wide"><%= request.getParameter("msg") %></p>
                </div>
                <button onclick="this.parentElement.remove()" class="text-emerald-100 hover:text-white"><i class="fa-solid fa-xmark"></i></button>
            </div>
        <% } %>

        <% if(request.getParameter("error") != null) { %>
            <div id="statusToast" class="flex items-center justify-between rounded-xl bg-rose-500/95 border border-rose-400/40 p-4 text-white shadow-lg backdrop-blur-md transition-all">
                <div class="flex items-center gap-3">
                    <i class="fa-solid fa-triangle-exclamation text-base"></i>
                    <p class="text-xs font-bold tracking-wide"><%= request.getParameter("error") %></p>
                </div>
                <button onclick="this.parentElement.remove()" class="text-rose-100 hover:text-white"><i class="fa-solid fa-xmark"></i></button>
            </div>
        <% } %>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

            <!-- Left Panel: Register New Doctor Form -->
            <div class="glass-card rounded-2xl border border-white/50 p-6 shadow-xl flex flex-col justify-between">
                <div>
                    <div class="flex items-center gap-2 border-b border-slate-200/60 pb-3 mb-4">
                        <i class="fa-solid fa-user-plus text-teal-600 text-sm"></i>
                        <h2 class="text-sm font-black text-slate-800 uppercase tracking-wider">Add New Doctor</h2>
                    </div>

                    <form action="${pageContext.request.contextPath}/DoctorManagementServlet" method="post" class="space-y-4">
                        <input type="hidden" name="action" value="addDoctor">
                        
                        <div>
                            <label class="block text-[10px] font-black tracking-wider text-slate-400 mb-1.5 uppercase">Doctor Full Name</label>
                            <input type="text" name="doctorName" placeholder="e.g. Dr. K. Perera" 
                                   class="w-full rounded-xl border border-slate-200/80 bg-slate-50/60 py-2.5 px-3.5 text-xs font-bold text-slate-800 placeholder-slate-400 focus:border-teal-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-teal-500 transition-all shadow-inner" required />
                        </div>

                        <div>
                            <label class="block text-[10px] font-black tracking-wider text-slate-400 mb-1.5 uppercase">Specialization</label>
                            <input type="text" name="specialization" placeholder="e.g., Orthodontist, Endodontist" 
                                   class="w-full rounded-xl border border-slate-200/80 bg-slate-50/60 py-2.5 px-3.5 text-xs font-bold text-slate-800 placeholder-slate-400 focus:border-teal-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-teal-500 transition-all shadow-inner" />
                        </div>

                        <button type="submit" class="w-full inline-flex items-center justify-center gap-2 rounded-xl bg-teal-600 px-4 py-3 text-xs font-black uppercase text-white shadow-md hover:bg-teal-500 transition-all active:scale-[0.98]">
                            <i class="fa-solid fa-plus text-xs"></i>
                            <span>Register Doctor</span>
                        </button>
                    </form>
                </div>

                <div class="mt-6 pt-4 border-t border-slate-200/60 text-[10px] text-slate-400 font-medium leading-relaxed">
                    <i class="fa-solid fa-circle-info text-teal-600 mr-1"></i>
                    Doctors registered here will become channelable by receptionists during patient appointment creation.
                </div>
            </div>

            <!-- Right Panel: Managed Doctors Roster & Treatment Mapping -->
            <div class="glass-card lg:col-span-2 rounded-2xl border border-white/50 p-6 shadow-xl space-y-5">
                <div class="flex items-center justify-between border-b border-slate-200/60 pb-3">
                    <div class="flex items-center gap-2">
                        <i class="fa-solid fa-list-check text-indigo-600 text-sm"></i>
                        <h2 class="text-sm font-black text-slate-800 uppercase tracking-wider">Active Doctors Roster</h2>
                    </div>
                    <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Admin Controls</span>
                </div>

                <div class="overflow-x-auto">
                    <table class="w-full border-collapse text-left text-xs text-slate-600">
                        <thead>
                            <tr class="border-b border-slate-200 bg-slate-100/60 font-black uppercase tracking-wider text-slate-400 text-[10px]">
                                <th scope="col" class="px-4 py-3">Doctor</th>
                                <th scope="col" class="px-4 py-3">Status</th>
                                <th scope="col" class="px-4 py-3">Assigned Treatments</th>
                                <th scope="col" class="px-4 py-3 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100 font-medium">
                        <%
                            try (Connection conn = DatabaseConnection.getInstance().getConnection()) {
                                // Fetch all treatments for the dropdown mapping modal/form
                                Map<Integer, String> allTreatments = new LinkedHashMap<>();
                                try (Statement stTreat = conn.createStatement();
                                     ResultSet rsTreat = stTreat.executeQuery("SELECT id, treatment_name FROM treatments ORDER BY treatment_name")) {
                                    while(rsTreat.next()) {
                                        allTreatments.put(rsTreat.getInt("id"), rsTreat.getString("treatment_name"));
                                    }
                                }

                                // Query Doctors
                                String docSql = "SELECT id, doctor_name, specialization, is_active FROM doctors ORDER BY doctor_name ASC";
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery(docSql);

                                boolean hasDoctors = false;
                                while(rs.next()) {
                                    hasDoctors = true;
                                    int docId = rs.getInt("id");
                                    String docName = rs.getString("doctor_name");
                                    String spec = rs.getString("specialization");
                                    boolean isActive = rs.getBoolean("is_active");

                                    // Get treatments assigned to this doctor
                                    List<Integer> assignedTreatmentIds = new ArrayList<>();
                                    String tSql = "SELECT treatment_id FROM doctor_treatments WHERE doctor_id = ?";
                                    try (PreparedStatement psT = conn.prepareStatement(tSql)) {
                                        psT.setInt(1, docId);
                                        ResultSet rsT = psT.executeQuery();
                                        while(rsT.next()) {
                                            assignedTreatmentIds.add(rsT.getInt("treatment_id"));
                                        }
                                    }
                        %>
                            <tr class="hover:bg-slate-50/50 transition-all">
                                <!-- Doctor Name & Specialization -->
                                <td class="px-4 py-3.5">
                                    <div class="flex flex-col">
                                        <span class="font-black text-slate-900 text-xs"><%= docName %></span>
                                        <span class="text-[10px] text-slate-400 font-medium"><%= spec %></span>
                                    </div>
                                </td>

                                <!-- Status Badge -->
                                <td class="px-4 py-3.5">
                                    <% if(isActive) { %>
                                        <span class="inline-flex items-center gap-1 rounded-full bg-emerald-100 px-2.5 py-0.5 text-[9px] font-black uppercase text-emerald-800 border border-emerald-200">
                                            <i class="fa-solid fa-circle text-[6px]"></i> Active
                                        </span>
                                    <% } else { %>
                                        <span class="inline-flex items-center gap-1 rounded-full bg-rose-100 px-2.5 py-0.5 text-[9px] font-black uppercase text-rose-800 border border-rose-200">
                                            <i class="fa-solid fa-circle text-[6px]"></i> Inactive
                                        </span>
                                    <% } %>
                                </td>

                                <!-- Treatment Assignment Form -->
                                <td class="px-4 py-3.5">
                                    <form action="${pageContext.request.contextPath}/DoctorManagementServlet" method="post" class="flex items-center gap-2">
                                        <input type="hidden" name="action" value="assignTreatments">
                                        <input type="hidden" name="doctorId" value="<%= docId %>">
                                        
                                        <select name="treatmentIds" multiple class="rounded-lg border border-slate-200 bg-slate-50/80 p-1.5 text-[10px] font-bold text-slate-700 focus:outline-none focus:ring-1 focus:ring-indigo-500 max-w-[180px] h-12">
                                            <% for(Map.Entry<Integer, String> entry : allTreatments.entrySet()) { 
                                                boolean selected = assignedTreatmentIds.contains(entry.getKey());
                                            %>
                                                <option value="<%= entry.getKey() %>" <%= selected ? "selected" : "" %>>
                                                    <%= entry.getValue() %>
                                                </option>
                                            <% } %>
                                        </select>

                                        <button type="submit" title="Save Treatment Authorization" class="rounded-lg bg-indigo-600 px-2.5 py-1.5 text-[10px] font-black uppercase text-white shadow-sm hover:bg-indigo-500 transition-all">
                                            <i class="fa-solid fa-floppy-disk"></i>
                                        </button>
                                    </form>
                                </td>

                                <!-- Actions: Toggle Availability -->
                                <td class="px-4 py-3.5 text-right">
                                    <form action="${pageContext.request.contextPath}/DoctorManagementServlet" method="post" class="inline">
                                        <input type="hidden" name="action" value="toggleStatus">
                                        <input type="hidden" name="doctorId" value="<%= docId %>">
                                        <input type="hidden" name="currentStatus" value="<%= isActive %>">
                                        
                                        <% if(isActive) { %>
                                            <button type="submit" class="rounded-lg bg-slate-200 px-2.5 py-1.5 text-[10px] font-black uppercase text-slate-700 hover:bg-rose-100 hover:text-rose-700 transition-all">
                                                Deactivate
                                            </button>
                                        <% } else { %>
                                            <button type="submit" class="rounded-lg bg-emerald-600 px-2.5 py-1.5 text-[10px] font-black uppercase text-white hover:bg-emerald-500 transition-all">
                                                Activate
                                            </button>
                                        <% } %>
                                    </form>
                                </td>
                            </tr>
                        <%
                                }
                                if(!hasDoctors) {
                        %>
                            <tr>
                                <td colspan="4" class="px-4 py-8 text-center text-xs font-bold text-slate-400">
                                    No doctors registered yet. Add a doctor using the form on the left.
                                </td>
                            </tr>
                        <%
                                }
                            } catch(Exception e) {
                        %>
                            <tr>
                                <td colspan="4" class="px-4 py-6 text-center text-xs font-bold text-rose-600">
                                    Error loading doctors: <%= e.getMessage() %>
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
</div>

<jsp:include page="../components/footer.jsp" />