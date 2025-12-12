<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title><%
        Object titleAttr = request.getAttribute("title");
        Object usernameAttr = request.getAttribute("username");
        String title = titleAttr != null ? titleAttr.toString() : null;
        String username = usernameAttr != null ? usernameAttr.toString() : null;
        String pageTitle = title != null ? title : (username != null ? "Profil de " + username : "Profil Utilisateur");
        out.print(pageTitle);
    %></title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 32px auto; line-height: 1.6; }
        h1 { margin-bottom: 12px; }
        .block { margin-bottom: 18px; padding: 12px; border: 1px solid #ddd; border-radius: 6px; }
        .muted { color: #666; }
    </style>
</head>
<body>
<%
    Object emailAttr = request.getAttribute("email");
    Object ageAttr = request.getAttribute("age");
    Object isActiveAttr = request.getAttribute("isActive");

    String email = emailAttr != null ? emailAttr.toString() : null;
    String age = ageAttr != null ? ageAttr.toString() : null;
    String isActive = isActiveAttr != null ? isActiveAttr.toString() : null;
%>

    <h1><%= pageTitle %></h1>

    <div class="block">
        <% if (username != null) { %><p><strong>Utilisateur:</strong> <%= username %></p><% } %>
        <% if (email != null) { %><p><strong>Email:</strong> <%= email %></p><% } %>
        <% if (age != null) { %><p><strong>Age:</strong> <%= age %></p><% } %>
        <% if (isActive != null) { %><p><strong>Statut:</strong> <%= "true".equalsIgnoreCase(isActive) ? "Actif" : "Inactif" %></p><% } %>
        <% if (username == null && email == null && age == null && isActive == null) { %>
            <p class="muted">Aucune information utilisateur transmise.</p>
        <% } %>
    </div>
</body>
</html>