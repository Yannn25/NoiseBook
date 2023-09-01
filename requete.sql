--Quels utilisateurs ont créé des playlists contenant des chansons de plus de 5 minutes de durée ?
SELECT DISTINCT u.username
FROM Users u
JOIN affiche af ON u.id_user = af.id_user
JOIN est_dans ed ON af.id_playlist = ed.id_playlist
JOIN Tracks t ON ed.id_track = t.id_track
WHERE t.duree > 5;

--Quels utilisateurs sont amis avec au moins un autre utilisateur et ont participé à des événements ?
SELECT DISTINCT u.username
FROM Users u
JOIN Ami a ON u.id_user = a.id_user_1
JOIN Participation p ON u.id_user = p.id_user

--Quels sont les artistes qui ont sorti des titres après l'année 2000 ?
SELECT DISTINCT a.nom_artiste
FROM Artistes a
JOIN Auteurs at ON a.id_artiste = at.id_artiste
JOIN  Tracks t ON at.id_artiste = t.id_track
WHERE t.year_publication > 2000;

--Quels utilisateurs ont assisté à des événements organisés par leurs amis ?
SELECT DISTINCT u.username
FROM Users u
JOIN Ami a ON u.id_user = a.id_user_1
JOIN Participation p ON u.id_user = p.id_user AND p.id_event = a.id_event;

--Quels sont les utilisateurs qui ont donné une note moyenne supérieure à 4 aux concerts auxquels ils ont participé ?
SELECT u.username
FROM Users u
JOIN Participation p ON u.id_user = p.id_user
JOIN Concerts c ON p.id_event = c.id_event
GROUP BY u.id_user
HAVING AVG(c.note) > 4;

--Quels utilisateurs ont créé des playlists contenant le plus grand nombre de chansons ?
SELECT u.username, COUNT(ed.id_track) AS nb_chansons
FROM Users u
JOIN affiche af ON u.id_user = af.id_user
JOIN est_dans ed ON af.id_playlist = ed.id_playlist
GROUP BY u.username
ORDER BY nb_chansons DESC
LIMIT 1;

--Quels utilisateurs n'ont pas d'amis ?
SELECT u.username
FROM Users u
LEFT JOIN Ami a ON u.id_user = a.id_user_1
WHERE a.id_user_2 IS NULL;

--Quels utilisateurs ont participé à des événements organisés par leurs amis et ont donné une note supérieure à 3 ?
SELECT DISTINCT u.username
FROM Users u
JOIN Ami a ON u.id_user = a.id_user_1
JOIN Participation p ON u.id_user = p.id_user AND p.id_event = a.id_event
JOIN Evenements e ON p.id_event = e.id_event
WHERE e.note > 3;

--Quels utilisateurs ont créé des playlists qui contiennent plus de chansons que la moyenne du nombre de chansons dans toutes les playlists ?
SELECT DISTINCT u.username
FROM Users u
JOIN Playlists pl ON u.id_user = pl.id_user
GROUP BY u.username
HAVING COUNT(pl.id_playlist) > (
    SELECT AVG(playlist_count)
    FROM (
        SELECT COUNT(id_playlist) AS playlist_count
        FROM Playlists
        GROUP BY id_user
    ) AS subquery
);

--View pour  tous les concerts qui auront lieu dans les 30 prochains jours
CREATE VIEW Vue_Concerts AS
SELECT evenement.nom_event AS nom_event, concert.date_event AS date_event, evenement.id_user_lieu AS id_user_lieu, evenement.id_user_association AS id_user_association, concert.description AS description, concert.prix_billets AS prix_billets
FROM Evenements evenement
JOIN Concerts concert ON evenement.id_event = concert.id_event;
SELECT nom_event, date_event
FROM Vue_Concerts
WHERE date_event BETWEEN CURRENT_DATE AND (CURRENT_DATE + INTERVAL '30 days');


PREPARE recherche_ville(VARCHAR) as
SELECT nom_lieu
FROM Lieux
WHERE ville LIKE '$1';

EXECUTE recherche_ville('Pa');