SELECT s.id_word, s.tf_idf
FROM statistique s
WHERE s.date_publication = CURRENT_DATE;

SELECT s.id_word, s.tf_idf
FROM statistique s
WHERE s.date_publication BETWEEN CURRENT_DATE-7 AND CURRENT_DATE;

SELECT s.id_word, s.tf_idf
FROM statistique s
WHERE s.date_publication BETWEEN CURRENT_DATE-30 AND CURRENT_DATE;

SELECT count(s.id_word)
FROM statistique s
WHERE s.date_publication = CURRENT_DATE;

SELECT count(s.id_word)
FROM statistique s
WHERE s.date_publication BETWEEN CURRENT_DATE-7 AND CURRENT_DATE;

SELECT count(s.id_word)
FROM statistique s
WHERE s.date_publication BETWEEN CURRENT_DATE-30 AND CURRENT_DATE;