<%
    String redirect = request.getParameter("redirect");
    session.invalidate();
    if(redirect==null || redirect.isEmpty()) redirect = "index.jsp";
    response.sendRedirect(redirect);
%>
