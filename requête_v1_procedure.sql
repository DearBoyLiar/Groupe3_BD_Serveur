--Groupe3_LauraBouzidi_CyrilGaillard_RemiVives_EnzoMartineau
--requete 1 : View the most common keywords of the week
	--Combien de mot (TOP ?)
	--Date : semaine d'avant ? semaine en cours ? quand recalculer ?

SELECT m.mot, count(m.mot)
FROM article a, mot m, mot_racine mr, position_mot pm 
WHERE m.id_racine = mr.id_racine
AND m.id_mot = pm.id_mot
AND pm.id_article = a.id_article
GROUP BY m.mot 
ORDER BY 2 DESC LIMIT 5;


--requete 2 : Show theme + percentage of number of articles 
--of this theme for the week

CREATE PROCEDURE percent_Theme (INOUT vTheme varchar(25), OUT vPercent FLOAT) 
BEGIN 
	SELECT c.classe, ((count(a.id_article)/(SELECT count(id_article) FROM article))*100) 
	INTO vTheme, vPercent
	FROM article a, appartient ap, classification c 
	WHERE c.classe = 'vTheme' 
	AND ap.id_classe = c.id_classe 
	AND ap.id_article = a.id_article; 
END;

--requete 3 : Top 10 sources with the most articles per week 
--(name of the source and number of articles)

SELECT j.nom_journal, count(a.id_article)
FROM article a , journal j
WHERE j.id_journal = a.id_journal
GROUP BY j.nom_journal
ORDER BY 2 DESC LIMIT 10;

--requete 4 : For each source, retrieve the link + the link of the image

SELECT DISTINCTj.nom_journal, j.lien_journal, j.lien_logo
FROM journal j;

--requete 5 : Most answered words / week for the selected theme
			--mot plus traités dans le titre ou dans les articles ?
SELECT c.classe, m.mot, count(m.mot)
FROM article a, classification c, mot m, mot_racine mr, position_mot pm
appartient ap 
WHERE m.id_racine = mr.id_racine
AND m.id_mot = pm.id_mot
AND pm.id_article = a.id_article
AND a.id_article = ap.id_article
AND c.id_classe = ap.id_classe
GROUP BY c.classe, m.mot 
ORDER BY 3 DESC LIMIT 5;

--requete 7 : Frequency of appearance of the word per week 
CREATE PROCEDURE frequency_Word (INOUT vWord varchar(50), OUT vfrequency FLOAT) 
BEGIN
	SELECT DISTINCT m.mot, ((count(m.mot)/(SELECT count(mot) FROM mot))*100) INTO vWord, vfrequency
	FROM article a, appartient ap, classification c, mot m, mot_racine mr, position_mot pm 
	WHERE m.id_racine = mr.id_racine
	AND m.id_mot = pm.id_mot
	AND pm.id_article = a.id_article
	AND ap.id_article = a.id_article
	AND c.id_classe = ap.id_classe
	AND m.mot = vWord;
END;

		
--requete 8 : Frequency of the word by source

CREATE PROCEDURE word_percent  (INOUT vSource varchar(50),
OUT vPercent FLOAT, OUT vWord varchar(50))
BEGIN
   SELECT m.mot, (count(m.mot)/(SELECT count(mot) FROM mot)) INTO vWord, vPercent
   FROM mot m, mot_racine mr, position_mot pm, article a, journal j
   WHERE m.id_racine = mr.id_racine
   AND m.id_mot = pm.id_mot
   AND pm.id_article = a.id_article
   AND j.id_journal = a.id_journal
   AND j.nom_journal=vSource;
END;


--requete 9 : Liste de mots associés au mot clé (nombre à définir)
CREATE PROCEDURE list_Key_Word (INOUT vWord varchar(50), OUT vSynonym varchar(50)) 
BEGIN
	SELECT s.synonyme INTO vSynonym
	FROM   mot m, mot_racine mr, position_mot pm, synonyme s
	WHERE m.id_racine = mr.id_racine
	AND m.id_mot = pm.id_mot
	AND pm.id_synonyme = s.id_synonyme
	AND m.mot = vWord;
END;


--requete 10 : Fréquence d'apparition du mot par thème
CREATE PROCEDURE frequency_Word_Theme (INOUT vWord varchar(50), OUT vfrequency FLOAT, OUT vclassication varchar(25))
BEGIN
	SELECT c.classe, m.mot, (count(m.mot)/(SELECT count(m.mot) FROM mot)) INTO vclassication, vWord, vfrequency
	FROM article a, appartient ap, classification c, mot m, mot_racine mr, position_mot pm   
	WHERE m.id_racine = mr.id_racine
	AND m.id_mot = pm.id_mot
	AND pm.id_article = a.id_article
	AND c.id_classe = ap.id_classe
	AND ap.id_article = a.id_article
	AND m.mot = vWord
	GROUP BY c.classe, m.mot;
END;

--requete 11 : compter le nombre de journaux

SELECT count(j.id_journal)
FROM journal j;

--requete 12 : ressortir tous les noms de journaux

SELECT DISTINCT j.nom_journal
FROM journal j;