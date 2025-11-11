<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <html>

    <head>
        <title>Profil Utilisateur</title>
    </head>

    <body>
        <h1>Profil de ${username}</h1>
        <p>Email: ${email}</p>
        <p>Âge: ${age}</p>
        <p>Statut: ${isActive ? 'Actif' : 'Inactif'}</p>
    </body>

    </html>