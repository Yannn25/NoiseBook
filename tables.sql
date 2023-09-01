CREATE DATABASE Noisebook;
\c noisebook;

DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Personnes;
DROP TABLE IF EXISTS Associations;
DROP TABLE IF EXISTS Lieux;
DROP TABLE IF EXISTS Groupes;
DROP TABLE IF EXISTS Playlists;
DROP TABLE IF EXISTS Tracks;
DROP TABLE IF EXISTS Avis;
DROP TABLE IF EXISTS Mot_Clefs;
DROP TABLE IF EXISTS Genre;
DROP TABLE IF EXISTS Sous_Genre;
DROP TABLE IF EXISTS Concerts;
DROP TABLE IF EXISTS A_Venir;
DROP TABLE IF EXISTS Fini;
DROP TABLE IF EXISTS Participation;
DROP TABLE IF EXISTS Annonce;
DROP TABLE IF EXISTS Figure;
DROP TABLE IF EXISTS Ami;
DROP TABLE IF EXISTS Follow;
DROP TABLE IF EXISTS Affiche;
DROP TABLE IF EXISTS est_dans;
DROP TABLE IF EXISTS Auteurs;
DROP TABLE IF EXISTS Line_up;
DROP TABLE IF EXISTS Style;
DROP TABLE IF EXISTS Tag_Event;
DROP TABLE IF EXISTS Tag_Genre;
DROP TABLE IF EXISTS Tag_Groupes;
DROP TABLE IF EXISTS Tag_Playlist;
DROP TABLE IF EXISTS Tag_Track;
DROP TABLE IF EXISTS React_Concert;
DROP TABLE IF EXISTS React_Spe_User;
DROP TABLE IF EXISTS React_Track;
CREATE TABLE Users(
   id_user INT PRIMARY KEY,
   username VARCHAR(30) NOT NULL
);

CREATE TABLE Associations (
   id_user INT PRIMARY KEY REFERENCES Users(id_user),
   nom_asso VARCHAR(128),
   cause VARCHAR(256),
   is_association BOOLEAN DEFAULT TRUE
);

CREATE TABLE Lieux (
   id_user INT PRIMARY KEY REFERENCES Users(id_user),
   nom_lieu VARCHAR(256) NOT NULL,
   adresse VARCHAR(256) NOT NULL,
   ville VARCHAR(256) NOT NULL,
   region VARCHAR(256),
   capacité INT,
   exterieur BOOLEAN NOT NULL,
   enfant BOOLEAN NOT NULL,
   is_lieu BOOLEAN DEFAULT TRUE
);

CREATE TABLE Groupes (
   id_user INT PRIMARY KEY REFERENCES Users(id_user),
   nom_artiste VARCHAR(256) NOT NULL,
   pays VARCHAR(128),
   is_groupe BOOLEAN DEFAULT TRUE
);

CREATE TABLE Personnes (
   id_user INT PRIMARY KEY REFERENCES Users(id_user),
   full_name VARCHAR(256) NOT NULL, 
   gender VARCHAR(8) NOT NULL,
   mail VARCHAR(64),
   ville VARCHAR(256) NOT NULL,
   is_personne BOOLEAN DEFAULT TRUE
);

CREATE TABLE Evenements (
   id_event INT PRIMARY KEY,
   nom_event VARCHAR(256) NOT NULL,
   date_event DATE NOT NULL,
   id_user_lieu INT NOT NULL REFERENCES Lieux(id_user),
   id_user_association INT NOT NULL REFERENCES Associations(id_user)
);

CREATE TABLE Concerts (
   id_event INT PRIMARY KEY REFERENCES Evenements(id_event),
   description TEXT,
   prix_billets INT
);

CREATE TABLE A_Venir (
   id_event INT PRIMARY KEY REFERENCES Concerts(id_event),
   places_dispo INT,
   is_finish BOOLEAN DEFAULT TRUE
);

CREATE TABLE Fini (
   id_event INT PRIMARY KEY REFERENCES Concerts(id_event),
   nb_participants INT,
   is_not_finish BOOLEAN DEFAULT TRUE
);

CREATE TABLE Playlists(
   id_playlist INT,
   nom_playlist VARCHAR(64) NOT NULL,
   PRIMARY KEY(id_playlist)
);

CREATE TABLE Tracks(
   id_track INT,
   titre VARCHAR(256),
   duree DECIMAL(8,2),
   year_publication INTEGER,
   PRIMARY KEY(id_track)
);

CREATE TABLE Genre(
   id_genre INT,
   nom_genre VARCHAR(256) NOT NULL,
   PRIMARY KEY(id_genre)
);

CREATE TABLE Mot_Clefs(
   id_tag INT,
   tag VARCHAR(256) NOT NULL,
   PRIMARY KEY(id_tag)
);

CREATE TABLE Avis(
   id_avis INT,
   contenu TEXT NOT NULL,
   note DECIMAL(2,1),
   id_user INT NOT NULL,
   PRIMARY KEY(id_avis),
   FOREIGN KEY(id_user) REFERENCES Personnes(id_user)
);

CREATE TABLE Participation(
   id_event INT,
   id_user INT,
   interet BOOLEAN NOT NULL,
   participe BOOLEAN NOT NULL,
   PRIMARY KEY(id_event, id_user),
   FOREIGN KEY(id_event) REFERENCES Evenements(id_event),
   FOREIGN KEY(id_user) REFERENCES Personnes(id_user)
);

CREATE TABLE Figure(
   id_avis INT,
   id_tag INT,
   PRIMARY KEY(id_avis, id_tag),
   FOREIGN KEY(id_avis) REFERENCES Avis(id_avis),
   FOREIGN KEY(id_tag) REFERENCES Mot_Clefs(id_tag)
);

CREATE TABLE Affiche(
   id_user INT,
   id_playlist INT,
   PRIMARY KEY(id_user, id_playlist),
   FOREIGN KEY(id_user) REFERENCES Users(id_user),
   FOREIGN KEY(id_playlist) REFERENCES Playlists(id_playlist)
);

CREATE TABLE est_dans(
   id_playlist INT,
   id_track INT,
   PRIMARY KEY(id_playlist, id_track),
   FOREIGN KEY(id_playlist) REFERENCES Playlists(id_playlist),
   FOREIGN KEY(id_track) REFERENCES Tracks(id_track)
);

CREATE TABLE Sous_Genre(
   id_genre INT,
   id_genre_1 INT,
   nom_sous_genre VARCHAR(256) NOT NULL,
   PRIMARY KEY(id_genre, id_genre_1),
   UNIQUE(nom_sous_genre),
   FOREIGN KEY(id_genre) REFERENCES Genre(id_genre),
   FOREIGN KEY(id_genre_1) REFERENCES Genre(id_genre)
);

CREATE TABLE Style(
   id_track INT,
   id_genre INT,
   PRIMARY KEY(id_track, id_genre),
   FOREIGN KEY(id_track) REFERENCES Tracks(id_track),
   FOREIGN KEY(id_genre) REFERENCES Genre(id_genre)
);

CREATE TABLE Ami(
   id_user INT,
   id_user_1 INT,
   PRIMARY KEY(id_user, id_user_1),
   FOREIGN KEY(id_user) REFERENCES Users(id_user),
   FOREIGN KEY(id_user_1) REFERENCES Users(id_user)
);

CREATE TABLE Follow(
   id_user INT,
   id_user_1 INT,
   PRIMARY KEY(id_user, id_user_1),
   FOREIGN KEY(id_user) REFERENCES Users(id_user),
   FOREIGN KEY(id_user_1) REFERENCES Users(id_user)
);

CREATE TABLE Annonce(
   id_user INT,
   id_event INT,
   PRIMARY KEY(id_user, id_event),
   FOREIGN KEY(id_user) REFERENCES Users(id_user),
   FOREIGN KEY(id_event) REFERENCES Evenements(id_event)
);

CREATE TABLE Tag_Event(
   id_tag INT,
   id_event INT,
   PRIMARY KEY(id_tag, id_event),
   FOREIGN KEY(id_tag) REFERENCES Mot_Clefs(id_tag),
   FOREIGN KEY(id_event) REFERENCES Evenements(id_event)
);

CREATE TABLE Tag_Track(
   id_track INT,
   id_tag INT,
   PRIMARY KEY(id_track, id_tag),
   FOREIGN KEY(id_track) REFERENCES Tracks(id_track),
   FOREIGN KEY(id_tag) REFERENCES Mot_Clefs(id_tag)
);

CREATE TABLE React_Spe_User(
   id_user INT,
   id_user_1 INT,
   PRIMARY KEY(id_user, id_user_1),
   FOREIGN KEY(id_user) REFERENCES Users(id_user),
   FOREIGN KEY(id_user_1) REFERENCES Personnes(id_user)
);

CREATE TABLE React_Track(
   id_track INT,
   id_user INT,
   PRIMARY KEY(id_track, id_user),
   FOREIGN KEY(id_track) REFERENCES Tracks(id_track),
   FOREIGN KEY(id_user) REFERENCES Personnes(id_user)
);

CREATE TABLE Line_up(
   id_user INT,
   id_event INT,
   PRIMARY KEY(id_user, id_event),
   FOREIGN KEY(id_user) REFERENCES Groupes(id_user),
   FOREIGN KEY(id_event) REFERENCES Concerts(id_event)
);

CREATE TABLE Tag_Groupes(
   id_tag INT,
   id_user INT,
   PRIMARY KEY(id_tag, id_user),
   FOREIGN KEY(id_tag) REFERENCES Mot_Clefs(id_tag),
   FOREIGN KEY(id_user) REFERENCES Groupes(id_user)
);

CREATE TABLE Auteurs(
   id_track INT,
   id_user INT,
   PRIMARY KEY(id_track, id_user),
   FOREIGN KEY(id_track) REFERENCES Tracks(id_track),
   FOREIGN KEY(id_user) REFERENCES Groupes(id_user)
);

CREATE TABLE React_Concert(
   id_user INT,
   id_event INT,
   PRIMARY KEY(id_user, id_event),
   FOREIGN KEY(id_user) REFERENCES Personnes(id_user),
   FOREIGN KEY(id_event) REFERENCES A_Venir(id_event)
);

CREATE TABLE Tag_Playlist(
   id_playlist INT,
   id_tag INT,
   PRIMARY KEY(id_playlist, id_tag),
   FOREIGN KEY(id_playlist) REFERENCES Playlists(id_playlist),
   FOREIGN KEY(id_tag) REFERENCES Mot_Clefs(id_tag)
);

CREATE TABLE Tag_Genre(
   id_genre INT,
   id_tag INT,
   PRIMARY KEY(id_genre, id_tag),
   FOREIGN KEY(id_genre) REFERENCES Genre(id_genre),
   FOREIGN KEY(id_tag) REFERENCES Mot_Clefs(id_tag)
);

ALTER TABLE Associations ADD CONSTRAINT exclusive_association CHECK (is_association = TRUE);
ALTER TABLE Personnes ADD CONSTRAINT exclusive_personne CHECK (is_personne = TRUE);
ALTER TABLE Lieux ADD CONSTRAINT exclusive_lieu CHECK (is_lieu = TRUE);
ALTER TABLE Groupes ADD CONSTRAINT exclusive_groupe CHECK (is_groupe = TRUE);

-- Contrainte surement nécessaire mais non possible a cause de nos données que ne sont pas unique
-- ALTER TABLE Lieux ADD CONSTRAINT unique_nom_lieu UNIQUE (nom_lieu);
-- ALTER TABLE Genre ADD CONSTRAINT unique_nom_genre UNIQUE (nom_genre);
-- ALTER TABLE Mot_Clefs ADD CONSTRAINT unique_tag UNIQUE (tag);

\copy Users FROM 'CSV/Users.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Associations FROM 'CSV/Associations.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Lieux FROM 'CSV/Lieux.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Groupes FROM 'CSV/Groupes.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Personnes FROM 'CSV/Personnes.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Playlists FROM 'CSV/Playlist.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Tracks FROM 'CSV/Tracks.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Genre FROM 'CSV/Genre.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Mot_Clefs FROM 'CSV/Mot_Clefs.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Avis FROM 'CSV/Avis.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Evenements FROM 'CSV/Evenements.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Concerts FROM 'CSV/Concerts.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy A_Venir FROM 'CSV/A_Venir.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Fini FROM 'CSV/Fini.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Participation FROM 'CSV/Participation.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Figure FROM 'CSV/Figure.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Affiche FROM 'CSV/Affiche.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy est_dans FROM 'CSV/est_dans.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Sous_Genre FROM 'CSV/Sous_Genre.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Style FROM 'CSV/Style.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Ami FROM 'CSV/Ami.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Follow FROM 'CSV/Follow.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Annonce FROM 'CSV/Annonce.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Tag_Event FROM 'CSV/Tag_Event.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Tag_Track FROM 'CSV/Tag_Track.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy React_Spe_User FROM 'CSV/React_Spe_User.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy React_Track FROM 'CSV/React_Track.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Line_up FROM 'CSV/Line_up.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Tag_Groupes FROM 'CSV/Tag_Groupes.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Auteurs FROM 'CSV/Auteurs.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy React_Concert FROM 'CSV/React_Concert.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Tag_Playlist FROM 'CSV/Tag_Playlist.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);
\copy Tag_Genre FROM 'CSV/Tag_Genre.csv' WITH (FORMAT 'csv', DELIMITER ',' , HEADER true);

