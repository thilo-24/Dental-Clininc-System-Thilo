<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunrisedental.config.DatabaseConnection, java.sql.*" %>
<%
    if(session.getAttribute("user") == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=Access Denied: Administrative Credentials Required");
        return;
    }
%>
<jsp:include page="../components/header.jsp" />

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
</style>

<div class="relative min-h-[85vh] rounded-3xl overflow-hidden p-4 sm:p-6 lg:p-10 border border-slate-200/60 shadow-xl bg-cover bg-center transition-all duration-700"
     style="background-image: url('https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=1920&q=80');">
    
    <div class="absolute inset-0 z-0 bg-gradient-to-tr from-slate-950/85 via-slate-900/40 to-indigo-950/20"></div>

    <div class="relative z-10 max-w-6xl mx-auto space-y-6">

        <!-- Page Header & Action HUD Navigation Block -->
        <div class="glass-hud-panel rounded-2xl border border-white/40 p-5 sm:p-6 shadow-lg shadow-slate-900/10">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
                <div>
                    <div class="flex items-center gap-2">
                        <span class="inline-flex h-6 w-6 items-center justify-center rounded-md bg-indigo-600 text-white shadow-sm">
                            <i class="fa-solid fa-scale-balanced text-[11px]"></i>
                        </span>
                        <h1 class="text-xl font-black tracking-tight text-slate-900 uppercase sm:text-2xl">Core Operational Fee Matrices</h1>
                    </div>
                    <p class="mt-1 text-xs sm:text-sm font-medium text-slate-500">Dynamically scale clinic catalog indices, map pricing models, and monitor real-time projections.</p>
                </div>
                <a href="dashboard.jsp" class="inline-flex items-center gap-2 self-start md:self-center rounded-xl border border-slate-200 bg-white/90 px-4 py-2 text-xs font-bold text-slate-700 shadow-sm transition-all hover:bg-slate-50 hover:text-slate-900 active:scale-[0.98] backdrop-blur-sm">
                    <i class="fa-solid fa-arrow-left-long text-slate-500"></i>
                    <span>Control Hub</span>
                </a>
            </div>
        </div>

        <!-- Alert Notification Pipeline -->
        <% if (request.getParameter("msg") != null) { %>
            <div class="p-4 rounded-xl bg-emerald-50/90 border border-emerald-200 text-xs font-bold text-emerald-800 backdrop-blur-sm shadow-sm flex items-center gap-2">
                <i class="fa-solid fa-circle-check text-emerald-500 text-sm"></i>
                <span><%= java.net.URLDecoder.decode(request.getParameter("msg"), "UTF-8") %></span>
            </div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="p-4 rounded-xl bg-rose-50/90 border border-rose-200 text-xs font-bold text-rose-800 backdrop-blur-sm shadow-sm flex items-center gap-2">
                <i class="fa-solid fa-circle-exclamation text-rose-500 text-sm"></i>
                <span><%= java.net.URLDecoder.decode(request.getParameter("error"), "UTF-8") %></span>
            </div>
        <% } %>

        <!-- Master Interface Layout Grid Split -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 items-start">
            
            <!-- Left Column Component: Complete Interactive Price Matrix Catalog Ledger Table -->
            <div class="lg:col-span-2 overflow-hidden rounded-2xl border border-white/50 bg-white/90 shadow-xl backdrop-blur-md flex flex-col justify-between min-h-[450px]">
                <div>
                    <div class="p-4 border-b border-slate-100 bg-slate-100/60 font-black uppercase tracking-wider text-slate-400 text-[10px] flex items-center justify-between">
                        <span class="flex items-center gap-2"><i class="fa-solid fa-layer-group text-indigo-500 text-xs"></i> Active Catalog Registries</span>
                        <span class="text-[9px] bg-indigo-100 text-indigo-700 px-2 py-0.5 rounded font-mono">Dynamic Mode</span>
                    </div>
                    
                    <div class="overflow-x-auto">
                        <table class="w-full border-collapse text-left text-xs text-slate-600">
                            <thead>
                                <tr class="border-b border-slate-200 bg-slate-50/40 font-black uppercase tracking-wider text-slate-400 text-[10px]">
                                    <th scope="col" class="px-6 py-4">Treatment Classification</th>
                                    <th scope="col" class="px-6 py-4 text-right">Baseline Fee (LKR)</th>
                                    <th scope="col" class="px-6 py-4 text-center">System Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100 font-medium">
                                <%
                                    try {
                                        Connection conn = DatabaseConnection.getInstance().getConnection();
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery("SELECT id, treatment_name, base_price FROM treatments ORDER BY id ASC");
                                        while(rs.next()) {
                                            int tId = rs.getInt("id");
                                            String tName = rs.getString("treatment_name");
                                            double tPrice = rs.getDouble("base_price");
                                %>
                                <tr class="transition-all duration-200 hover:bg-indigo-50/40 group" id="row-<%= tId %>">
                                    <form action="../TreatmentManagementServlet" method="post" class="inline">
                                        <input type="hidden" name="actionType" value="UPDATE" />
                                        <input type="hidden" name="treatmentId" value="<%= tId %>" />
                                        
                                        <!-- Procedure Identification Vector Layout Cell -->
                                        <td class="whitespace-nowrap px-6 py-4 text-sm font-bold text-slate-800">
                                            <div class="flex items-center gap-3">
                                                <div class="flex h-7 w-7 items-center justify-center rounded-lg bg-gradient-to-br from-slate-100 to-slate-200 border border-slate-300/60 text-[11px] text-slate-600 font-black transition-all duration-300 group-hover:from-indigo-600 group-hover:to-blue-600 group-hover:text-white shadow-inner">
                                                    <i class="fa-solid fa-tooth"></i>
                                                </div>
                                                <span id="label-name-<%= tId %>" class="tracking-wide text-slate-900"><%= tName %></span>
                                                <input type="text" name="treatmentName" value="<%= tName %>" id="input-name-<%= tId %>" 
                                                       class="hidden rounded-lg border border-slate-300 px-2 py-1 text-xs w-40 focus:outline-none focus:ring-1 focus:ring-indigo-500 font-bold" required />
                                            </div>
                                        </td>
                                        
                                        <!-- Baseline System Pricing Form Input Layout Cell -->
                                        <td class="whitespace-nowrap px-6 py-4 text-right text-sm font-black text-slate-900 font-mono tracking-tight">
                                            <span id="label-price-<%= tId %>" class="group-hover:text-indigo-600"><%= String.format("%,.2f", tPrice) %></span>
                                            <input type="number" step="0.01" name="basePrice" value="<%= tPrice %>" id="input-price-<%= tId %>" 
                                                   class="hidden rounded-lg border border-slate-300 p-1 text-xs text-right w-28 focus:outline-none focus:ring-1 focus:ring-indigo-500 font-black font-mono" required />
                                        </td>
                                        
                                        <!-- System Operational Processing Button Arrays Action Cell -->
                                        <td class="whitespace-nowrap px-6 py-4 text-center">
                                            <div class="flex items-center justify-center gap-1.5">
                                                <!-- Edit Command Controller Trigger Trigger -->
                                                <button type="button" id="btn-edit-<%= tId %>" onclick="enableRowEditing(<%= tId %>)" class="inline-flex h-7 w-7 items-center justify-center rounded-lg bg-slate-100 border border-slate-200 hover:bg-indigo-600 hover:text-white text-slate-500 shadow-sm transition-all duration-200">
                                                    <i class="fa-solid fa-pen-to-square text-[10px]"></i>
                                                </button>
                                                <!-- Direct Form Save Action Frame Execution Execution Button -->
                                                <button type="submit" id="btn-save-<%= tId %>" class="hidden inline-flex h-7 w-7 items-center justify-center rounded-lg bg-emerald-600 text-white border border-transparent hover:bg-emerald-500 shadow-sm transition-all duration-200">
                                                    <i class="fa-solid fa-floppy-disk text-[10px]"></i>
                                                </button>
                                                <!-- Revoke Cancel Buffer Mode UI Reset Button -->
                                                <button type="button" id="btn-cancel-<%= tId %>" onclick="cancelRowEditing(<%= tId %>)" class="hidden inline-flex h-7 w-7 items-center justify-center rounded-lg bg-slate-500 text-white border border-transparent hover:bg-slate-400 shadow-sm transition-all duration-200">
                                                    <i class="fa-solid fa-xmark text-[10px]"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </form>
                                    
                                    <!-- Independent Detached Drop Execution Sub-Form Element Node Context -->
                                    <td class="hidden">
                                        <form id="delete-form-<%= tId %>" action="../TreatmentManagementServlet" method="post" onsubmit="return confirm('Drop this structural procedure catalog asset permanently?');">
                                            <input type="hidden" name="actionType" value="DELETE" />
                                            <input type="hidden" name="treatmentId" value="<%= tId %>" />
                                        </form>
                                    </td>
                                    <!-- Append standard removal trigger button alongside main frame loop actions -->
                                    <td class="whitespace-nowrap pr-6 py-4 text-left">
                                        <button type="submit" form="delete-form-<%= tId %>" class="inline-flex h-7 w-7 items-center justify-center rounded-lg bg-slate-100 border border-slate-200 hover:bg-rose-600 hover:text-white hover:border-transparent text-slate-400 shadow-sm transition-all duration-200 active:scale-[0.93]">
                                            <i class="fa-solid fa-trash-can text-[10px]"></i>
                                        </button>
                                    </td>
                                </tr>
                                <%
                                        }
                                        rs.close(); stmt.close();
                                    } catch (Exception e) {
                                %>
                                <tr>
                                    <td colspan="4" class="px-6 py-8 text-center text-xs font-bold text-rose-600 bg-rose-50/20">
                                        <i class="fa-solid fa-circle-exclamation animate-pulse mr-1"></i> Registry connection error encountered. Check connection profiles.
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Provision Dynamic New Account Node Treatment Sub-Form Layer Entry Workspace -->
                <div class="p-4 bg-slate-50 border-t border-slate-200 backdrop-blur-sm mt-auto">
                    <h4 class="text-[10px] uppercase font-black tracking-wider text-slate-400 mb-2.5 flex items-center gap-1.5"><i class="fa-solid fa-plus text-indigo-500"></i> Add New Treatment Classification Node</h4>
                    <form action="../TreatmentManagementServlet" method="post" class="grid grid-cols-1 sm:grid-cols-3 gap-3 items-end">
                        <input type="hidden" name="actionType" value="INSERT" />
                        <div>
                            <input type="text" name="treatmentName" placeholder="Procedure Signature Name" required
                                   class="w-full rounded-xl border border-slate-200 bg-white py-1.5 px-3 text-xs font-bold text-slate-700 focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 transition-all shadow-sm" />
                        </div>
                        <div>
                            <input type="number" step="0.01" name="basePrice" placeholder="Baseline Rate (LKR)" required
                                   class="w-full rounded-xl border border-slate-200 bg-white py-1.5 px-3 text-xs font-bold text-slate-700 font-mono focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 transition-all shadow-sm" />
                        </div>
                        <button type="submit" class="w-full inline-flex items-center justify-center gap-2 rounded-xl bg-slate-900 hover:bg-slate-800 text-white font-black tracking-wide uppercase text-[10px] py-2 transition-all shadow-sm active:scale-[0.98]">
                            <i class="fa-solid fa-plus-circle"></i> <span>Commit Node</span>
                        </button>
                    </form>
                </div>
            </div>

            <!-- Right Column Widget Component Layer Element: Dynamic Calculation Interface Projections Emulator -->
            <div class="glass-matrix-card rounded-2xl border border-white/50 p-5 shadow-xl backdrop-blur-md flex flex-col justify-between min-h-[450px]">
                <div>
                    <h3 class="text-[10px] font-black tracking-wider text-slate-400 uppercase mb-4 flex items-center gap-2 border-b border-slate-200/60 pb-3">
                        <i class="fa-solid fa-calculator text-indigo-500 text-xs"></i> Tax and Total Estimator
                    </h3>
                    
                    <div class="space-y-4">
                        <div>
                            <label class="block text-[10px] font-black text-slate-400 mb-1.5 uppercase tracking-wider">Select Procedure Base</label>
                            <select id="calcBase" onchange="runCalculation()" class="w-full rounded-xl border border-slate-200 bg-slate-50/60 p-2.5 text-xs font-bold text-slate-700 focus:border-indigo-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500 transition-all shadow-inner cursor-pointer">
                                <%
                                    try {
                                        Connection conn = DatabaseConnection.getInstance().getConnection();
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery("SELECT treatment_name, base_price FROM treatments ORDER BY id ASC");
                                        while(rs.next()) {
                                %>
                                    <option value="<%= rs.getDouble("base_price") %>"><%= rs.getString("treatment_name") %></option>
                                <%
                                        }
                                        rs.close(); stmt.close();
                                    } catch(Exception e) {}
                                %>
                            </select>
                        </div>
                        
                        <div>
                            <label class="block text-[10px] font-black text-slate-400 mb-1.5 uppercase tracking-wider">Add-on Clinic Tax (%)</label>
                            <input type="number" id="calcTax" value="10" onkeyup="runCalculation()" onchange="runCalculation()"
                                   class="w-full rounded-xl border border-slate-200 bg-slate-50/60 p-2.5 text-xs font-bold text-slate-700 focus:border-indigo-500 focus:bg-white focus:outline-none focus:ring-1 focus:ring-indigo-500 transition-all font-mono shadow-inner" min="0" max="100"/>
                        </div>
                    </div>
                </div>

                <div class="pt-4 mt-6 border-t border-dashed border-slate-200 space-y-2.5">
                    <div class="flex justify-between text-xs text-slate-500 font-medium">
                        <span>Base Value:</span>
                        <span id="outBase" class="font-bold font-mono text-slate-700">0.00 LKR</span>
                    </div>
                    <div class="flex justify-between text-xs text-slate-500 font-medium">
                        <span>Tax Surcharge:</span>
                        <span id="outTax" class="font-bold font-mono text-slate-700">0.00 LKR</span>
                    </div>
                    <div class="flex justify-between items-center text-sm text-slate-900 pt-3 border-t border-slate-200/60">
                        <span class="font-black text-xs text-slate-500 uppercase tracking-wider">Estimated Total:</span>
                        <span id="outTotal" class="font-black font-mono text-indigo-600 text-base tracking-tight bg-indigo-50 px-2.5 py-1 rounded-lg border border-indigo-100 shadow-sm">0.00 LKR</span>
                    </div>
                </div>
            </div>
            
        </div>

    </div>
</div>

<script>
    // Inline Client Row Swapping Operations Controller View Engine
    function enableRowEditing(id) {
        document.getElementById('label-name-' + id).classList.add('hidden');
        document.getElementById('label-price-' + id).classList.add('hidden');
        document.getElementById('btn-edit-' + id).classList.add('hidden');
        
        document.getElementById('input-name-' + id).classList.remove('hidden');
        document.getElementById('input-price-' + id).classList.remove('hidden');
        document.getElementById('btn-save-' + id).classList.remove('hidden');
        document.getElementById('btn-cancel-' + id).classList.remove('hidden');
    }

    function cancelRowEditing(id) {
        document.getElementById('input-name-' + id).classList.add('hidden');
        document.getElementById('input-price-' + id).classList.add('hidden');
        document.getElementById('btn-save-' + id).classList.add('hidden');
        document.getElementById('btn-cancel-' + id).classList.add('hidden');
        
        document.getElementById('label-name-' + id).classList.remove('hidden');
        document.getElementById('label-price-' + id).classList.remove('hidden');
        document.getElementById('btn-edit-' + id).classList.remove('hidden');
    }

    function runCalculation() {
        const baseVal = parseFloat(document.getElementById('calcBase').value) || 0;
        const taxPercent = parseFloat(document.getElementById('calcTax').value) || 0;
        
        const taxAmount = baseVal * (taxPercent / 100);
        const ultimateTotal = baseVal + taxAmount;
        
        document.getElementById('outBase').textContent = baseVal.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2}) + " LKR";
        document.getElementById('outTax').textContent = taxAmount.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2}) + " LKR";
        document.getElementById('outTotal').textContent = ultimateTotal.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2}) + " LKR";
    }

    document.addEventListener("DOMContentLoaded", () => {
        runCalculation();
    });
</script>

<jsp:include page="../components/footer.jsp" />