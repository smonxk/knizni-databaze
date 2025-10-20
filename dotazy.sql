
Ukaž mi roky obdržených cen, jejich ID a ID autorů, kteří je obdrželi.
SELECT rok AS "Rok obdržení", id_oceneni AS "ID obdržené ceny", id_autor AS "ID autora"
FROM Autor_oceneni;


Ukaž mi datum narození a národnost A. S. Puškina.
SELECT jmeno as "Jméno",
narozeni as "Datum narození", 
narodnost as "Národnost"
FROM osoba o
JOIN autor a ON o.id_osoba = a.id_osoba
WHERE o.jmeno = 'Alexandr S.' AND prijmeni = 'Puskin';


Jména a příjmení autorů, kteří neobdrželi žádné ocenění
SELECT DISTINCT jmeno AS "Jméno autora",
                prijmeni AS "Příjmení autora"
FROM (
    SELECT DISTINCT *
    FROM AUTOR
    EXCEPT
    SELECT DISTINCT id_autor,
                    id_osoba,
                    narozeni,
                    smrt,
                    narodnost
    FROM AUTOR
    NATURAL JOIN AUTOR_OCENENI
) R1
NATURAL JOIN OSOBA;


ID , jméno a příjmení autora, který napsal Bílou nemoc.
SELECT  a.id_autor AS "ID autora",
        jmeno AS "Jméno autora",
        prijmeni AS "Příjmení autora"
FROM kniha k
JOIN autorstvi au ON au.id_kniha = k.id_kniha
JOIN autor a ON a.id_autor = au.id_autor
JOIN osoba o ON a.id_autor = o.id_osoba 
WHERE k.nazev = 'Bila nemoc';


Ukaž mi uživatelská jména a email těch čtenářů, kteří dočetli a ohodnotili Annu Kareninu deseti body.
SELECT DISTINCT username AS "Uživatelské jméno",
                email AS "Email uživatele"
FROM (
    SELECT DISTINCT *
    FROM Kniha
    WHERE nazev = 'Anna Karenina'
)
NATURAL JOIN (
    SELECT DISTINCT *
    FROM Ctenarstvi
    WHERE stav_cteni = 'precteno'
)
NATURAL JOIN Ctenar
NATURAL JOIN (
    SELECT DISTINCT *
    FROM Recenze
    WHERE body = '10'
) R1;


Kniha bez filmového zpracování.
SELECT DISTINCT k.nazev as "Název knihy", o.jmeno as "Jméno autora", o.prijmeni as "Příjmení autora"
FROM Kniha k
JOIN autorstvi au ON k.id_kniha = au.id_kniha
JOIN autor a ON au.id_autor = a.id_autor
JOIN osoba o ON a.id_osoba = o.id_osoba
WHERE NOT EXISTS (
    SELECT 1
    FROM Filmove_zpracovani f
    WHERE k.id_kniha = f.id_kniha
);




Ukaž mi pouze knihy, které napsala Simone de Beauvoir a nikdo jiný.
SELECT k.nazev as "Název knihy", k.isbn
FROM Osoba o
     JOIN Autor a ON o.id_osoba = a.id_osoba
     JOIN Autorstvi ast ON a.id_autor = ast.id_autor
     JOIN Kniha k ON ast.id_kniha = k.id_kniha
WHERE o.jmeno = 'Simone'and o.prijmeni = 'de Beauvoir'
EXCEPT
SELECT k.nazev, k.isbn
FROM Osoba o
     JOIN Autor a ON o.id_osoba = a.id_osoba
     JOIN Autorstvi ast ON a.id_autor = ast.id_autor
     JOIN Kniha k ON ast.id_kniha = k.id_kniha
WHERE o.jmeno != 'Simone' and o.prijmeni != 'de Beauvoir';


Čtenáři, který četl buďto Mieko Kawakami nebo Harukiho Murakamiho, ale nečetli obojí.
(SELECT c.*
 FROM Ctenar c
      JOIN ctenarstvi ct ON c.id_ctenar = ct.id_ctenar
      JOIN kniha k ON ct.id_kniha = k.id_kniha
      JOIN autorstvi au ON k.id_kniha = au.id_kniha
      JOIN autor a ON au.id_autor = a.id_autor
      JOIN osoba o ON a.id_osoba = o.id_osoba
 WHERE o.jmeno = 'Mieko' and o.prijmeni = 'Kawakami'
 UNION
 SELECT DISTINCT c.*
  FROM Ctenar c
      JOIN ctenarstvi ct ON c.id_ctenar = ct.id_ctenar
      JOIN kniha k ON ct.id_kniha = k.id_kniha
      JOIN autorstvi au ON k.id_kniha = au.id_kniha
      JOIN autor a ON au.id_autor = a.id_autor
      JOIN osoba o ON a.id_osoba = o.id_osoba
 WHERE o.jmeno = 'Haruki' and o.prijmeni = 'Murakami')
EXCEPT
(SELECT DISTINCT c.*
 FROM Ctenar c
      JOIN ctenarstvi ct ON c.id_ctenar = ct.id_ctenar
      JOIN kniha k ON ct.id_kniha = k.id_kniha
      JOIN autorstvi au ON k.id_kniha = au.id_kniha
      JOIN autor a ON au.id_autor = a.id_autor
      JOIN osoba o ON a.id_osoba = o.id_osoba
 WHERE o.jmeno = 'Mieko' and o.prijmeni = 'Kawakami'
 INTERSECT
 SELECT DISTINCT c.*
 FROM Ctenar c
      JOIN ctenarstvi ct ON c.id_ctenar = ct.id_ctenar
      JOIN kniha k ON ct.id_kniha = k.id_kniha
      JOIN autorstvi au ON k.id_kniha = au.id_kniha
      JOIN autor a ON au.id_autor = a.id_autor
      JOIN osoba o ON a.id_osoba = o.id_osoba
 WHERE o.jmeno = 'Haruki' and o.prijmeni = 'Murakami');


Známý člověk, který navštívil každý křest knihy.
SELECT z.id_zcl, o.jmeno, o.prijmeni, z.status
FROM Znamy_clovek z
JOIN Osoba o ON z.id_osoba = o.id_osoba
WHERE NOT EXISTS (
  SELECT 1
  FROM Krest_knihy k
  WHERE NOT EXISTS (
    SELECT 1
    FROM Navsteva_krtu nk
    WHERE nk.id_krtu = k.id_krtu
    AND nk.id_osoba = z.id_osoba
  )
)
ORDER BY o.jmeno;


kolik by bylo potřeba recenzí, aby každý literární kritik napsal právě jednu recenzi pro každou knihu
SELECT 
    COUNT(*) AS potrebnych_recenzi, -- pocet potrebnych recenzi
    COUNT(DISTINCT id_kniha) AS pocet_knih -- pocet ruznych knih
FROM literarni_kritik
     CROSS JOIN kniha;



Seznam autorů, kteří mají alespoň 2 knihy ve stavu 'přečteno', celkový počet knih v databázi od těchto autorů, kolikrát jsou jejich knihy zaznamenáný jako přečtené a kolikrát jako rozečtené. Seřazeno sestupně podle toho, kolikrát byly knihy autorů označeny jako přečtené.
SELECT o.jmeno, o.prijmeni,
       COUNT(DISTINCT k.id_kniha) AS celkovy_pocet_knih_autora,
       -- počet všech knih, které byly označeny jako 'precteno' (i vícekrát)
       SUM(CASE WHEN ct.stav_cteni = 'precteno' THEN 1 ELSE 0 END) AS knihy_precteny_celkem,
       -- počet všech knih, které byly označeny jako 'rozecteno' (i vícekrát)
       SUM(CASE WHEN ct.stav_cteni = 'rozecteno' THEN 1 ELSE 0 END) AS knihy_rozecteny_celkem
FROM osoba o
JOIN autor a ON o.id_osoba = a.id_osoba
JOIN autorstvi au ON a.id_autor = au.id_autor
JOIN kniha k ON au.id_kniha = k.id_kniha
JOIN ctenarstvi ct ON k.id_kniha = ct.id_kniha
WHERE ct.stav_cteni IN ('precteno', 'rozecteno')
GROUP BY o.jmeno, o.prijmeni


Seznam autorů, jejich jména a příjmení, nejstarší datum napsání knihy (v databázi) , název nejstarší knihy, název nejstaršího filmu založeného na této knize (pokud existuje) a režisér tohoto filmu (pokud existuje). Pokud film na základě knihy neexistuje, bude uvedeno 'BEZ ZPRACOVÁNÍ'
SELECT o.jmeno as "jméno autora", 
       o.prijmeni as "příjmení autora", 
       
       -- nejstarší datum napsání knihy pro daného autora (získané vnořeným SELECTem z tabulky autorstvi)
       (SELECT MIN(a.rok_napsani) 
        FROM autorstvi a 
        WHERE a.id_osoba = o.id_osoba) AS "rok napsání nejstarší knihy",
       
       -- název nejstarší knihy (s odpovídajícím nejstarším datem napsání z tabulky autorstvi)
       (SELECT k.nazev 
        FROM kniha k 
        JOIN autorstvi a ON k.id_kniha = a.id_kniha
        WHERE a.id_osoba = o.id_osoba

Vyber všechny osobnosti (jméno a příjmení) a všechny knihy (název a ISBN), včetně informací o tom, zda je daná osobnost kmotrem nebo autorem těchto knih. Pokud osobnost není spojena s žádnou knihou (jako autor nebo kmotr) zahrň je ve výsledku také. Výstup seřaď podle příjmení a jména osobností, a následně podle názvu knihy, vše ve vzestupném pořadí.
SELECT 
    o.jmeno AS jmeno_osobnosti,
    o.prijmeni AS prijmeni_osobnosti,
    k.nazev AS nazev_knihy,
    k.isbn,
    COALESCE(
        CASE 
            WHEN a.id_autor IS NOT NULL THEN 'Autorem'
            WHEN km.id_osoba IS NOT NULL THEN 'Kmotrem'
        END,
        'Ostatní'
    ) AS role
FROM osoba o
FULL OUTER JOIN autor a ON o.id_osoba = a.id_osoba
FULL OUTER JOIN autorstvi au ON a.id_autor = au.id_autor
FULL OUTER JOIN kmotr_knihy km ON o.id_osoba = km.id_osoba
FULL OUTER JOIN kniha k ON k.id_kniha = COALESCE(au.id_kniha, km.id_kniha)
ORDER BY  k.nazev;


Jména knih hodnocených velmi zapšklými kritiky...
SELECT 
    v.id_kritik, 
    v."Jméno zapšklého kritika" , 
    v."Příjmení zapšklého kritika",  
    k.nazev AS "Název knihy", 
    r.body AS "Hodnocení"
FROM velmizapsklikritici v
JOIN recenze r ON v.id_kritik = r.id_kritik
JOIN kniha k ON r.id_kniha = k.id_kniha
ORDER BY v."Příjmení zapšklého kritika", v."Jméno zapšklého kritika", k.nazev;



Začneme transakci, zjistíme počet záznamů v tabulce krest_knihy, poté vložíme 3 náhodné knihy s místem a datem křtu do této tabulky (a zobrazíme si je). Po vložení zkontrolujeme počet záznamů a následně transakci zrušíme, čímž se vrátíme k původnímu stavu.
BEGIN;

-- počet záznamů před insert
SELECT COUNT(*)
FROM krest_knihy;

-- vložení náhodných dat
INSERT INTO krest_knihy (id_kniha, misto_krestu, datum_krestu)
SELECT id_kniha, 
       (ARRAY['Praha', 'Londýn', 'Peking'])[FLOOR(RANDOM() * 3) + 1] AS misto_krestu, 
       NOW() - RANDOM() * INTERVAL '50 years' AS datum_krestu   -- Náhodné datum křtu v posledních 50 letech
FROM kniha
WHERE id_kniha NOT IN (SELECT id_kniha FROM krest_knihy) -- nebudou vlozeny knihy s krestem
ORDER BY RANDOM()
LIMIT 3;

--  počet záznamů po vložení
SELECT COUNT(*) AS "Počet řádků" FROM krest_knihy;
-- jsem zvědavá, co tam počítač naházel
SELECT * FROM krest_knihy;

-- ruším změny
ROLLBACK;

-- je stav jako před transakcí?
SELECT COUNT(*)
FROM krest_knihy;


Vydavatel z tabulky první vydavatel, který nikoho ještě nevydal, bude přejmenován na Velelenocha.
BEGIN;

-- Zkontrolujeme vydavatele, kteří ještě nevydali žádnou knihu
SELECT pv.id_vyd, pv.nazev
FROM prvni_vydavatel pv
LEFT JOIN prvni_vydani pvyd ON pv.id_vyd = pvyd.id_vyd
WHERE pvyd.id_vyd IS NULL;

-- Provedeme update: přejmenujeme vydavatele, kteří nevydali žádnou knihu
UPDATE prvni_vydavatel
SET nazev = 'velelenoch'
WHERE id_vyd IN (
    SELECT pv.id_vyd
    FROM prvni_vydavatel pv
    LEFT JOIN prvni_vydani pvyd ON pv.id_vyd = pvyd.id_vyd
    WHERE pvyd.id_vyd IS NULL
);

-- Zkontrolujeme, jak jsme data změnili
SELECT pv.id_vyd, pv.nazev
FROM prvni_vydavatel pv
LEFT JOIN prvni_vydani pvyd ON pv.id_vyd = pvyd.id_vyd
WHERE pvyd.id_vyd IS NULL;

-- Zrušíme změny, pokud chceme testovat transakci bez trvalého zápisu
ROLLBACK;

-- Zkontrolujeme stav jako před transakcí
SELECT pv.id_vyd, pv.nazev
FROM prvni_vydavatel pv
LEFT JOIN prvni_vydani pvyd ON pv.id_vyd = pvyd.id_vyd
WHERE pvyd.id_vyd IS NULL;



Smaž ty lit. kritiky, kteří jsou velmi zapšklí kritici.
BEGIN;
SELECT COUNT(id_kritik) as "Počet kritiků celkem"
FROM literarni_kritik;

-- Zkontrolujeme si, že nám poddotaz vrací potřebná ID literárních kritiků, které budeme mazat
SELECT COUNT(id_kritik) as "Počet zapšklých kritiků"
FROM velmizapsklikritici;

-- Provedeme smazání literárních kritiků, kteří jsou v tabulce velmizlikritici
DELETE
FROM literarni_kritik
WHERE id_kritik IN (SELECT id_kritik FROM velmizapsklikritici);

-- Ověříme, že byly kritici úspěšně smazáni
SELECT COUNT(id_kritik) as "Počet kritiků celkem"
FROM literarni_kritik;

-- Vrátíme zpět všechny změny
ROLLBACK;


Detaily o knihách, jeijchž první vydání bylo před rokem 2000.
SELECT f.id_kniha, f.rok_vydani, k.nazev, k.isbn, k.id_jazyk, k.id_litsmer
FROM prvni_vydani f
JOIN kniha k ON f.id_kniha = k.id_kniha
WHERE f.rok_vydani < 2000
ORDER BY k.nazev;



Dva autoři, kteří napsali knihu se stejným názvem
SELECT 
    o1.jmeno AS jmeno_autora1,
    o1.prijmeni AS prijmeni_autora1,
    k1.id_kniha AS id_kniha1, 
    a1.rok_napsani AS rok_napsani1, 
    o2.jmeno AS jmeno_autora2,
    o2.prijmeni AS prijmeni_autora2,
    k2.id_kniha AS id_kniha2, 
    a2.rok_napsani AS rok_napsani2, 
    k1.nazev AS nazev_knihy
FROM 
    kniha k1
JOIN 
    autorstvi a1 ON k1.id_kniha = a1.id_kniha
JOIN 
    kniha k2 ON k1.nazev = k2.nazev  
JOIN 
    autorstvi a2 ON k2.id_kniha = a2.id_kniha
JOIN 
    osoba o1 ON a1.id_osoba = o1.id_osoba  
JOIN 
    osoba o2 ON a2.id_osoba = o2.id_osoba  
WHERE 
    a1.id_autor < a2.id_autor  
ORDER BY 
    k1.nazev;

Dva autoři, kteří napsali knihu se stejným názvem, ale zároveň to není ta stejná kniha (tj. nejsou spoluautory)
SELECT 
    o1.jmeno AS jmeno_autora1,
    o1.prijmeni AS prijmeni_autora1,
    k1.id_kniha AS id_kniha1, 
    a1.rok_napsani AS rok_napsani1, 
    o2.jmeno AS jmeno_autora2,
    o2.prijmeni AS prijmeni_autora2,
    k2.id_kniha AS id_kniha2, 
    a2.rok_napsani AS rok_napsani2, 
    k1.nazev AS nazev_knihy
FROM 
    kniha k1
JOIN 
    autorstvi a1 ON k1.id_kniha = a1.id_kniha
JOIN 
    kniha k2 ON k1.nazev = k2.nazev and k1.id_kniha != k2.id_kniha
JOIN 
    autorstvi a2 ON k2.id_kniha = a2.id_kniha
JOIN 
    osoba o1 ON a1.id_osoba = o1.id_osoba  
JOIN 
    osoba o2 ON a2.id_osoba = o2.id_osoba  
WHERE 
    a1.id_autor < a2.id_autor  
ORDER BY 
    k1.nazev;


Známý člověk, který navštívil nejvíce křtů ze všech známých osob, také znám jako "Známý vymetač křtů"...
SELECT 
    o.jmeno AS "Známý vymetač křtů", 
    o.prijmeni, 
    COUNT(kk.id_kniha) AS pocet_navstivenych_krtu
FROM 
    znamy_clovek z
JOIN 
    osoba o ON o.id_osoba = z.id_osoba
JOIN
    navsteva_krtu nk ON o.id_osoba = nk.id_osoba
JOIN 
    krest_knihy kk ON kk.id_kniha = nk.id_kniha
GROUP BY 
    o.jmeno, o.prijmeni
ORDER BY 
    pocet_navstivenych_krtu DESC
LIMIT 1;




Ukaž mi autory, kteří ještě žijí
SELECT 
    a.id_autor,
    o.jmeno,
    o.prijmeni,
    a.narozeni,
    COALESCE(TO_CHAR(a.smrt, 'YYYY-MM-DD'), 'ŽÁDNÁ! :-)') AS smrt --musím to přetypovat, protože v řádcích smrti je formát datum!
FROM 
    autor a
JOIN 
    osoba o ON a.id_osoba = o.id_osoba
WHERE 
    a.smrt IS NULL;








