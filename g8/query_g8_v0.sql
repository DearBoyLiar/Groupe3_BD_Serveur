CREATE PROCEDURE date_word (IN vnombre INT) 
BEGIN
	SELECT s.id_word, s.id_article, id s.tf_idf
	FROM statistique s
	WHERE s.date_publication = CURRENT_DATE-vnombre;
END;


CREATE PROCEDURE word_count (IN vnombre INT) 
BEGIN
	SELECT count(s.id_word)
	FROM statistique s
	WHERE s.date_publication = CURRENT_DATE-vnombre;
END;
