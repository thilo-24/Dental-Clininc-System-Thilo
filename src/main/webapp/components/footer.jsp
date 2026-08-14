<main><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    </main>

    <!-- Modern E-Commerce Grade Footer Segment -->
    <footer class="mt-auto border-t border-slate-200 bg-white">
        <div class="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
            <div class="flex flex-col sm:flex-row items-center justify-between gap-4 border-b border-slate-100 pb-6">
                
                <!-- Small branding metadata footprint -->
                <div class="flex items-center gap-2 opacity-75">
                    <i class="fa-solid fa-laptop-medical text-sky-600 text-base"></i>
                    <span class="text-xs font-bold text-slate-500 tracking-wider uppercase">Sunrise Dental Care System v2.1</span>
                </div>
                
                <!-- Quick Navigation Support Actions Help Fields -->
                <div class="flex flex-wrap justify-center gap-x-6 gap-y-2 text-xs font-semibold text-slate-400">
	                   <a href="<%= request.getContextPath() %>/components/help-section.jsp" 
						   class="hover:text-sky-600 cursor-pointer flex items-center">
						   <i class="fa-solid fa-circle-question mr-1 text-sky-500"></i> Helpdesk Documentation
					   </a>
                    <span class="hover:text-sky-600 cursor-pointer flex items-center"><i class="fa-solid fa-shield-halved mr-1 text-sky-500"></i> Privacy Guard Statement</span>
                    <span class="hover:text-sky-600 cursor-pointer flex items-center"><i class="fa-solid fa-server mr-1 text-sky-500"></i> DB Node Status: Active</span>
                </div>
            </div>
            
            <!-- Structural Copyright Matrix Parameters -->
            <div class="flex flex-col sm:flex-row items-center justify-between gap-2 pt-4 text-center sm:text-left">
                <p class="text-[11px] font-medium text-slate-400">&copy; <%= java.time.Year.now().getValue() %> Sunrise Dental Care Inc. All core operating privileges protected under enterprise validation laws.</p>
                <p class="text-[10px] font-bold tracking-wider text-slate-300 uppercase">Engine Architecture Execution Module</p>
            </div>
        </div>
    </footer>

</body>
</html>