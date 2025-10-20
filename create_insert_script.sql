-- Remove conflicting tables
DROP TABLE IF EXISTS autor CASCADE;
DROP TABLE IF EXISTS autor_oceneni CASCADE;
DROP TABLE IF EXISTS autorsmer CASCADE;
DROP TABLE IF EXISTS autorstvi CASCADE;
DROP TABLE IF EXISTS ctenar CASCADE;
DROP TABLE IF EXISTS ctenarstvi CASCADE;
DROP TABLE IF EXISTS filmove_zpracovani CASCADE;
DROP TABLE IF EXISTS jazyk CASCADE;
DROP TABLE IF EXISTS kmotr_knihy CASCADE;
DROP TABLE IF EXISTS kniha CASCADE;
DROP TABLE IF EXISTS krest_knihy CASCADE;
DROP TABLE IF EXISTS lit_smer CASCADE;
DROP TABLE IF EXISTS literarni_kritik CASCADE;
DROP TABLE IF EXISTS literarni_oceneni CASCADE;
DROP TABLE IF EXISTS navsteva_krtu CASCADE;
DROP TABLE IF EXISTS osoba CASCADE;
DROP TABLE IF EXISTS preklad CASCADE;
DROP TABLE IF EXISTS prekladatel CASCADE;
DROP TABLE IF EXISTS prvni_vydani CASCADE;
DROP TABLE IF EXISTS prvni_vydavatel CASCADE;
DROP TABLE IF EXISTS recenze CASCADE;
DROP TABLE IF EXISTS znamy_clovek CASCADE;


-- Create the 'osoba' table first (no dependencies)
CREATE TABLE osoba (
    id_osoba SERIAL NOT NULL,
    jmeno VARCHAR(256) NOT NULL,
    prijmeni VARCHAR(256) NOT NULL,
    PRIMARY KEY (id_osoba)
);

-- Create the 'jazyk' table
CREATE TABLE jazyk (
    id_jazyk SERIAL NOT NULL,
    nazev VARCHAR(256) NOT NULL,
    PRIMARY KEY (id_jazyk)
);


-- Create the 'lit_smer' table
CREATE TABLE lit_smer (
    id_litsmer SERIAL NOT NULL,
    nazev VARCHAR(256) NOT NULL,
    datum_vzniku DATE NOT NULL,
    PRIMARY KEY (id_litsmer),
    CONSTRAINT uc_lit_smer_nazev UNIQUE (nazev)
);

-- Create the 'literarni_oceneni' table
CREATE TABLE literarni_oceneni (
    id_oceneni SERIAL NOT NULL,
    nazev VARCHAR(256) NOT NULL,
    PRIMARY KEY (id_oceneni),
    CONSTRAINT uc_literarni_oceneni_nazev UNIQUE (nazev)
);

-- Create the 'literarni_kritik' table
CREATE TABLE literarni_kritik (
    id_kritik SERIAL NOT NULL,
    id_osoba INTEGER NOT NULL,
    vybiravy VARCHAR(256) NOT NULL,
    PRIMARY KEY (id_kritik),
    CONSTRAINT u_fk_literarni_kritik_osoba UNIQUE (id_osoba),
    CONSTRAINT fk_literarni_kritik_osoba FOREIGN KEY (id_osoba) REFERENCES osoba (id_osoba) ON DELETE CASCADE
);

-- Create the 'prekladatel' table
CREATE TABLE prekladatel (
    id_prekladatel SERIAL NOT NULL,
    id_osoba INTEGER NOT NULL,
    narodnost VARCHAR(256) NOT NULL,
    PRIMARY KEY (id_prekladatel),
    CONSTRAINT u_fk_prekladatel_osoba UNIQUE (id_osoba),
    CONSTRAINT fk_prekladatel_osoba FOREIGN KEY (id_osoba) REFERENCES osoba (id_osoba) ON DELETE CASCADE
);

-- Create the 'kniha' table
CREATE TABLE kniha (
    id_kniha SERIAL NOT NULL,
    id_jazyk INTEGER NOT NULL,
    id_litsmer INTEGER NOT NULL,
    nazev VARCHAR(256) NOT NULL,
    isbn BIGINT NOT NULL,
    PRIMARY KEY (id_kniha),
    CONSTRAINT uc_kniha_isbn UNIQUE (isbn),
    CONSTRAINT fk_kniha_jazyk FOREIGN KEY (id_jazyk) REFERENCES jazyk (id_jazyk) ON DELETE CASCADE,
    CONSTRAINT fk_kniha_litsmer FOREIGN KEY (id_litsmer) REFERENCES lit_smer (id_litsmer) ON DELETE CASCADE
);

-- Create the 'ctenar' table
CREATE TABLE ctenar (
    id_ctenar SERIAL NOT NULL,
    username VARCHAR(256) NOT NULL,
    email VARCHAR(256) NOT NULL,
    datum_registrace DATE,
    PRIMARY KEY (id_ctenar),
    CONSTRAINT uc_ctenar_email UNIQUE (email)
);

CREATE TABLE ctenarstvi (
    id_ctenar INTEGER NOT NULL,
    id_kniha INTEGER NOT NULL,
    stav_cteni VARCHAR(256) NOT NULL,
    PRIMARY KEY (id_ctenar, id_kniha),
    CONSTRAINT fk_ctenarstvi_ctenar FOREIGN KEY (id_ctenar) REFERENCES ctenar (id_ctenar) ON DELETE CASCADE,
    CONSTRAINT fk_ctenarstvi_kniha FOREIGN KEY (id_kniha) REFERENCES kniha (id_kniha) ON DELETE CASCADE
);


-- Create the 'prvni_vydavatel' table
CREATE TABLE prvni_vydavatel (
    id_vyd SERIAL NOT NULL,
    nazev VARCHAR(256) NOT NULL,
    PRIMARY KEY (id_vyd),
    CONSTRAINT uc_prvni_vydavatel_nazev UNIQUE (nazev)
);

CREATE TABLE prvni_vydani (
    id_kniha INTEGER NOT NULL,
    id_vyd INTEGER NOT NULL,
    pocet_stran VARCHAR(256),
    rok_vydani INTEGER NOT NULL,
    PRIMARY KEY (id_kniha, id_vyd), -- Composite primary key allows multiple rows with the same id_vyd
    CONSTRAINT u_fk_prvni_vydani_kniha UNIQUE (id_kniha), -- Keep id_kniha unique if needed
    -- Removed the UNIQUE constraint on id_vyd
    CONSTRAINT fk_prvni_vydani_kniha FOREIGN KEY (id_kniha) REFERENCES kniha (id_kniha) ON DELETE CASCADE,
    CONSTRAINT fk_prvni_vydani_vydavatel FOREIGN KEY (id_vyd) REFERENCES prvni_vydavatel (id_vyd) ON DELETE CASCADE
);


CREATE TABLE filmove_zpracovani (
    id_film SERIAL NOT NULL,
    id_jazyk INTEGER NOT NULL,
    id_kniha INTEGER NOT NULL,
    nazev VARCHAR(256) NOT NULL,
    reziser VARCHAR(256) NOT NULL,
    rok_vydani INTEGER NOT NULL
);
ALTER TABLE filmove_zpracovani ADD CONSTRAINT pk_filmove_zpracovani PRIMARY KEY (id_film);

-- Create the 'autor' table
CREATE TABLE autor (
    id_autor SERIAL NOT NULL,
    id_osoba INTEGER NOT NULL,
    narozeni DATE NOT NULL,
    smrt DATE,
    narodnost VARCHAR(256) NOT NULL,
    PRIMARY KEY (id_autor),
    CONSTRAINT u_fk_autor_osoba UNIQUE (id_osoba),
    CONSTRAINT fk_autor_osoba FOREIGN KEY (id_osoba) REFERENCES osoba (id_osoba) ON DELETE CASCADE
);

-- Create the 'autor_oceneni' table
CREATE TABLE autor_oceneni (
    id_autor INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL,
    id_oceneni INTEGER NOT NULL,
    rok INTEGER NOT NULL,
    PRIMARY KEY (id_autor, id_osoba, id_oceneni),
    CONSTRAINT fk_autor_oceneni_autor FOREIGN KEY (id_autor) REFERENCES autor (id_autor) ON DELETE CASCADE,
    CONSTRAINT fk_autor_oceneni_literarni_ocen FOREIGN KEY (id_oceneni) REFERENCES literarni_oceneni (id_oceneni) ON DELETE CASCADE
);

-- Create the 'autorsmer' table
CREATE TABLE autorsmer (
    id_autor INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL,
    id_litsmer INTEGER NOT NULL,
    datum_zacleneni DATE NOT NULL,
    PRIMARY KEY (id_autor, id_osoba, id_litsmer),
    CONSTRAINT fk_autorsmer_autor FOREIGN KEY (id_autor) REFERENCES autor (id_autor) ON DELETE CASCADE,
    CONSTRAINT fk_autorsmer_lit_smer FOREIGN KEY (id_litsmer) REFERENCES lit_smer (id_litsmer) ON DELETE CASCADE
);

-- Create the 'autorstvi' table
CREATE TABLE autorstvi (
    id_autor INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL,
    id_kniha INTEGER NOT NULL,
    rok_napsani INTEGER NOT NULL,
    PRIMARY KEY (id_autor, id_osoba, id_kniha),
    CONSTRAINT fk_autorstvi_autor FOREIGN KEY (id_autor) REFERENCES autor (id_autor) ON DELETE CASCADE,
    CONSTRAINT fk_autorstvi_kniha FOREIGN KEY (id_kniha) REFERENCES kniha (id_kniha) ON DELETE CASCADE
);

-- Create the 'preklad' table
CREATE TABLE preklad (
    id_jazyk INTEGER NOT NULL,
    id_kniha INTEGER NOT NULL,
    id_prekladatel INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL,
    rok_prekladu INTEGER NOT NULL,
    PRIMARY KEY (id_jazyk, id_kniha, id_prekladatel, id_osoba),
    CONSTRAINT fk_preklad_kniha FOREIGN KEY (id_kniha) REFERENCES kniha (id_kniha) ON DELETE CASCADE,
    CONSTRAINT fk_preklad_jazyk FOREIGN KEY (id_jazyk) REFERENCES jazyk (id_jazyk) ON DELETE CASCADE,
    CONSTRAINT fk_preklad_prekladatel FOREIGN KEY (id_prekladatel) REFERENCES prekladatel (id_prekladatel) ON DELETE CASCADE
);

-- Create the 'recenze' table with UNIQUE constraints and nullable fields
CREATE TABLE recenze (
    id_kniha INTEGER NOT NULL,
    id_ctenar INTEGER,
    id_kritik INTEGER,
    id_osoba INTEGER,
    body INTEGER NOT NULL,
    datum DATE NOT NULL,

    -- Foreign keys
    CONSTRAINT fk_recenze_kniha FOREIGN KEY (id_kniha) REFERENCES kniha (id_kniha) ON DELETE CASCADE,
    CONSTRAINT fk_recenze_ctenar FOREIGN KEY (id_ctenar) REFERENCES ctenar (id_ctenar) ON DELETE CASCADE,
    CONSTRAINT fk_recenze_literarni_kritik FOREIGN KEY (id_kritik) REFERENCES literarni_kritik (id_kritik) ON DELETE CASCADE,

    -- Ensure that either id_ctenar or id_kritik is NOT NULL, but not both
    CONSTRAINT check_ctenar_or_kritik CHECK (
        (id_ctenar IS NOT NULL AND id_kritik IS NULL) OR
        (id_ctenar IS NULL AND id_kritik IS NOT NULL)
    ),

    -- Ensure that if id_kritik is provided, there must be a corresponding id_osoba
    CONSTRAINT check_osoba_with_kritik CHECK (
        (id_kritik IS NOT NULL AND id_osoba IS NOT NULL) OR
        (id_kritik IS NULL)
    ),
    
    -- Define a UNIQUE constraint for the combination of id_kniha, id_ctenar, and id_kritik
    CONSTRAINT uq_recenze UNIQUE (id_kniha, id_ctenar, id_kritik)
);

-- Create the 'znamy_clovek' table
CREATE TABLE znamy_clovek (
    id_zcl SERIAL NOT NULL,
    id_osoba INTEGER NOT NULL,
    status VARCHAR(256),
    PRIMARY KEY (id_zcl),
    CONSTRAINT fk_znamy_clovek_osoba FOREIGN KEY (id_osoba) REFERENCES osoba (id_osoba) ON DELETE CASCADE
);

CREATE TABLE kmotr_knihy (
    id_krtu INTEGER NOT NULL,
    id_kniha INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL,
    vztah_k_autorovi VARCHAR(256)
);
ALTER TABLE kmotr_knihy ADD CONSTRAINT pk_kmotr_knihy PRIMARY KEY (id_krtu, id_kniha, id_osoba);
ALTER TABLE kmotr_knihy ADD CONSTRAINT u_fk_kmotr_knihy_krest_knihy UNIQUE (id_krtu, id_kniha);
ALTER TABLE kmotr_knihy ADD CONSTRAINT u_fk_kmotr_knihy_osoba UNIQUE (id_osoba);

CREATE TABLE navsteva_krtu (
    id_krtu INTEGER NOT NULL,
    id_kniha INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL
);
ALTER TABLE navsteva_krtu ADD CONSTRAINT pk_navsteva_krtu PRIMARY KEY (id_krtu, id_kniha, id_osoba);
-- Create the 'krest_knihy' table (restored)
CREATE TABLE krest_knihy (
    id_krtu SERIAL NOT NULL,
    id_kniha INTEGER NOT NULL,
    misto_krestu VARCHAR(256),
    datum_krestu DATE,
    PRIMARY KEY (id_krtu, id_kniha),
    CONSTRAINT u_fk_krest_knihy_kniha UNIQUE (id_kniha),
    CONSTRAINT fk_krest_knihy_kniha FOREIGN KEY (id_kniha) REFERENCES kniha (id_kniha) ON DELETE CASCADE
);

INSERT INTO public.jazyk (id_jazyk, nazev) VALUES (1, 'Cestina');
INSERT INTO public.jazyk (id_jazyk, nazev) VALUES (2, 'Rustina');
INSERT INTO public.jazyk (id_jazyk, nazev) VALUES (3, 'Japonstina');
INSERT INTO public.jazyk (id_jazyk, nazev) VALUES (4, 'Francouzstina');
INSERT INTO public.jazyk (id_jazyk, nazev) VALUES (5, 'Anglictina');
INSERT INTO public.jazyk (id_jazyk, nazev) VALUES (6, 'Nemcina');
INSERT INTO public.jazyk (id_jazyk, nazev) VALUES (7, 'Polstina');

INSERT INTO public.lit_smer (id_litsmer, nazev, datum_vzniku) VALUES (1, 'Realismus', '1850-01-01');
INSERT INTO public.lit_smer (id_litsmer, nazev, datum_vzniku) VALUES (3, 'Modernismus', '1910-01-01');
INSERT INTO public.lit_smer (id_litsmer, nazev, datum_vzniku) VALUES (4, 'Psychologický román', '1850-01-01');
INSERT INTO public.lit_smer (id_litsmer, nazev, datum_vzniku) VALUES (5, 'Magicky realismus', '1930-01-01');
INSERT INTO public.lit_smer (id_litsmer, nazev, datum_vzniku) VALUES (6, 'Existencialismus', '1940-01-01');
INSERT INTO public.lit_smer (id_litsmer, nazev, datum_vzniku) VALUES (2, 'Romantismus', '1780-12-31');
INSERT INTO public.lit_smer (id_litsmer, nazev, datum_vzniku) VALUES (7, 'Damska literatura', '1990-01-01');
INSERT INTO public.lit_smer (id_litsmer, nazev, datum_vzniku) VALUES (8, 'Detska literatura', '1658-01-01');
INSERT INTO public.lit_smer (id_litsmer, nazev, datum_vzniku) VALUES (9, 'Moderní fantasy', '1858-01-01');
INSERT INTO public.lit_smer (id_litsmer, nazev, datum_vzniku) VALUES (10, 'Humoristicka literatura', '1400-01-01');

INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (1, 'Haruki', 'Murakami');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (2, 'Karel', 'Capek');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (3, 'Alexandr S.', 'Puskin');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (4, 'Lev N.', 'Tolstoj');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (6, 'Simone', 'de Beauvoir');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (7, 'Edgar A.', 'Poe');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (8, 'Mieko', 'Kawakami');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (9, 'Krtitel', 'Knih');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (10, 'Krotitel', 'Knih');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (11, 'Leos', 'Mares');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (12, 'Pepa', 'Lichozrout');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (13, 'Pepa', 'Sudozrout');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (14, 'Sladislav', 'Kysely');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (15, 'Prokop', 'Rastinator');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (16, 'Hana', 'Uhlirova');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (17, 'Josef', 'Kostohryz');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (18, 'Vitezslav', 'Nezval');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (19, 'Jan', 'Levor');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (20, 'Anna', 'Krivankova');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (21, 'Hynek', 'Koc');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (22, 'Vera', 'Kresadlova');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (23, 'Jiri', 'Hilcr');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (24, 'Jan', 'Rak');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (25, 'Sam', 'Bett');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (26, 'David', 'Boyd');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (27, 'Norman', 'Tucker');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (28, 'Louis', 'Dopsch');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (29, 'Alexandr', 'Karpov');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (30, 'Frances', 'Hodgson Burnett');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (31, 'Katie', 'Fforde');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (32, 'Terry', 'Pratchett');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (33, 'Neil', 'Gaiman');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (34, 'Andreas M.', 'Fliedner');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (35, 'Petr', 'Kotrla');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (36, 'Michel', 'Pagel');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (37, 'Halina', 'Pawlowska');
INSERT INTO public.osoba (id_osoba, jmeno, prijmeni) VALUES (38, 'Jolanta', 'Młynarczyk');

INSERT INTO public.literarni_oceneni (id_oceneni, nazev) VALUES (1, 'Nobelova cena za literaturu');
INSERT INTO public.literarni_oceneni (id_oceneni, nazev) VALUES (2, 'Man Booker International Prize');
INSERT INTO public.literarni_oceneni (id_oceneni, nazev) VALUES (3, 'Puskinova cena');
INSERT INTO public.literarni_oceneni (id_oceneni, nazev) VALUES (4, 'Cena Andreje Belyho');
INSERT INTO public.literarni_oceneni (id_oceneni, nazev) VALUES (5, 'Statni cena za literaturu');
INSERT INTO public.literarni_oceneni (id_oceneni, nazev) VALUES (6, 'Prix Goncourt');
INSERT INTO public.literarni_oceneni (id_oceneni, nazev) VALUES (7, 'Akutagawova cena');
INSERT INTO public.literarni_oceneni (id_oceneni, nazev) VALUES (8, 'Tanizakiho cena');
INSERT INTO public.literarni_oceneni (id_oceneni, nazev) VALUES (9, 'Damon Knight Memorial Grand Master Award');
INSERT INTO public.literarni_oceneni (id_oceneni, nazev) VALUES (10, 'Bram Stoker Award');
INSERT INTO public.literarni_oceneni (id_oceneni, nazev) VALUES (11, 'World Fantasy Award');

INSERT INTO public.autor (id_autor, id_osoba, narozeni, smrt, narodnost) VALUES (1, 1, '1949-01-12', null, 'Japonec');
INSERT INTO public.autor (id_autor, id_osoba, narozeni, smrt, narodnost) VALUES (2, 2, '1980-01-09', '1938-12-25', 'Cech');
INSERT INTO public.autor (id_autor, id_osoba, narozeni, smrt, narodnost) VALUES (3, 3, '1799-06-06', '1837-02-10', 'Rus');
INSERT INTO public.autor (id_autor, id_osoba, narozeni, smrt, narodnost) VALUES (4, 4, '1828-09-09', '1910-11-20', 'Rus');
INSERT INTO public.autor (id_autor, id_osoba, narozeni, smrt, narodnost) VALUES (6, 6, '1908-01-09', '1986-04-14', 'Francouzka');
INSERT INTO public.autor (id_autor, id_osoba, narozeni, smrt, narodnost) VALUES (7, 7, '1809-01-19', '1849-10-07', 'American');
INSERT INTO public.autor (id_autor, id_osoba, narozeni, smrt, narodnost) VALUES (8, 8, '1976-08-29', null, 'Japonka');
INSERT INTO public.autor (id_autor, id_osoba, narozeni, smrt, narodnost) VALUES (9, 30, '1849-11-24', '1924-10-29', 'Britka');
INSERT INTO public.autor (id_autor, id_osoba, narozeni, smrt, narodnost) VALUES (10, 31, '1952-09-27', null, 'Britka');
INSERT INTO public.autor (id_autor, id_osoba, narozeni, smrt, narodnost) VALUES (11, 32, '1948-04-28', '2015-03-12', 'Brit');
INSERT INTO public.autor (id_autor, id_osoba, narozeni, smrt, narodnost) VALUES (12, 33, '1960-11-10', null, 'Brit');
INSERT INTO public.autor (id_autor, id_osoba, narozeni, smrt, narodnost) VALUES (13, 37, '1954-12-21', null, 'Polka');

INSERT INTO public.autor_oceneni (id_autor, id_osoba, id_oceneni, rok) VALUES (1, 1, 2, 2006);
INSERT INTO public.autor_oceneni (id_autor, id_osoba, id_oceneni, rok) VALUES (1, 1, 1, 2023);
INSERT INTO public.autor_oceneni (id_autor, id_osoba, id_oceneni, rok) VALUES (4, 4, 4, 1885);
INSERT INTO public.autor_oceneni (id_autor, id_osoba, id_oceneni, rok) VALUES (3, 3, 3, 1820);
INSERT INTO public.autor_oceneni (id_autor, id_osoba, id_oceneni, rok) VALUES (2, 2, 5, 1948);
INSERT INTO public.autor_oceneni (id_autor, id_osoba, id_oceneni, rok) VALUES (6, 6, 6, 1954);
INSERT INTO public.autor_oceneni (id_autor, id_osoba, id_oceneni, rok) VALUES (8, 8, 7, 2008);
INSERT INTO public.autor_oceneni (id_autor, id_osoba, id_oceneni, rok) VALUES (8, 8, 8, 2013);
INSERT INTO public.autor_oceneni (id_autor, id_osoba, id_oceneni, rok) VALUES (11, 32, 9, 2010);
INSERT INTO public.autor_oceneni (id_autor, id_osoba, id_oceneni, rok) VALUES (11, 32, 10, 1990);
INSERT INTO public.autor_oceneni (id_autor, id_osoba, id_oceneni, rok) VALUES (12, 33, 11, 2002);
INSERT INTO public.autor_oceneni (id_autor, id_osoba, id_oceneni, rok) VALUES (12, 33, 10, 1990);

INSERT INTO public.autorsmer (id_autor, id_osoba, id_litsmer, datum_zacleneni) VALUES (4, 4, 1, '1852-01-01');
INSERT INTO public.autorsmer (id_autor, id_osoba, id_litsmer, datum_zacleneni) VALUES (3, 3, 2, '1820-01-01');
INSERT INTO public.autorsmer (id_autor, id_osoba, id_litsmer, datum_zacleneni) VALUES (4, 4, 2, '1855-01-01');
INSERT INTO public.autorsmer (id_autor, id_osoba, id_litsmer, datum_zacleneni) VALUES (2, 2, 3, '1921-01-21');
INSERT INTO public.autorsmer (id_autor, id_osoba, id_litsmer, datum_zacleneni) VALUES (1, 1, 4, '1987-09-04');
INSERT INTO public.autorsmer (id_autor, id_osoba, id_litsmer, datum_zacleneni) VALUES (1, 1, 5, '1985-03-09');
INSERT INTO public.autorsmer (id_autor, id_osoba, id_litsmer, datum_zacleneni) VALUES (7, 7, 2, '1839-01-01');
INSERT INTO public.autorsmer (id_autor, id_osoba, id_litsmer, datum_zacleneni) VALUES (6, 6, 6, '1930-01-01');
INSERT INTO public.autorsmer (id_autor, id_osoba, id_litsmer, datum_zacleneni) VALUES (8, 8, 4, '2008-05-17');
INSERT INTO public.autorsmer (id_autor, id_osoba, id_litsmer, datum_zacleneni) VALUES (10, 31, 7, '1995-01-01');
INSERT INTO public.autorsmer (id_autor, id_osoba, id_litsmer, datum_zacleneni) VALUES (9, 30, 8, '1888-01-01');
INSERT INTO public.autorsmer (id_autor, id_osoba, id_litsmer, datum_zacleneni) VALUES (12, 33, 9, '1989-01-01');
INSERT INTO public.autorsmer (id_autor, id_osoba, id_litsmer, datum_zacleneni) VALUES (11, 32, 9, '1983-11-24');
INSERT INTO public.autorsmer (id_autor, id_osoba, id_litsmer, datum_zacleneni) VALUES (13, 37, 10, '1997-01-01');

INSERT INTO public.kniha (id_kniha, id_jazyk, id_litsmer, nazev, isbn) VALUES (1, 1, 1, 'Anna Karenina', 9788020811751);
INSERT INTO public.kniha (id_kniha, id_jazyk, id_litsmer, nazev, isbn) VALUES (2, 1, 2, 'Evzen Onegin', 9788020613155);
INSERT INTO public.kniha (id_kniha, id_jazyk, id_litsmer, nazev, isbn) VALUES (3, 1, 3, 'Bila nemoc', 9788073080863);
INSERT INTO public.kniha (id_kniha, id_jazyk, id_litsmer, nazev, isbn) VALUES (4, 1, 4, 'Norske drevo', 9788020429772);
INSERT INTO public.kniha (id_kniha, id_jazyk, id_litsmer, nazev, isbn) VALUES (5, 1, 5, 'Kafka na pobrezi', 9788020418530);
INSERT INTO public.kniha (id_kniha, id_jazyk, id_litsmer, nazev, isbn) VALUES (6, 1, 2, 'Havran a jine basne', 9788075330726);
INSERT INTO public.kniha (id_kniha, id_jazyk, id_litsmer, nazev, isbn) VALUES (7, 1, 6, 'Druhe pohlavi', 9788072675652);
INSERT INTO public.kniha (id_kniha, id_jazyk, id_litsmer, nazev, isbn) VALUES (8, 1, 4, 'Nebe', 9788020721624);
INSERT INTO public.kniha (id_kniha, id_jazyk, id_litsmer, nazev, isbn) VALUES (9, 5, 4, 'All the Lovers in the Night', 9781509898299);
INSERT INTO public.kniha (id_kniha, id_jazyk, id_litsmer, nazev, isbn) VALUES (11, 1, 7, 'Tajna zahrada', 9788024918922);
INSERT INTO public.kniha (id_kniha, id_jazyk, id_litsmer, nazev, isbn) VALUES (10, 1, 8, 'Tajna zahrada', 9788000017186);
INSERT INTO public.kniha (id_kniha, id_jazyk, id_litsmer, nazev, isbn) VALUES (12, 1, 9, 'Dobra znameni', 9788071970996);
INSERT INTO public.kniha (id_kniha, id_jazyk, id_litsmer, nazev, isbn) VALUES (13, 1, 10, 'Zoufale zeny delaji zoufale veci', 9788072373775);

INSERT INTO public.autorstvi (id_autor, id_osoba, id_kniha, rok_napsani) VALUES (1, 1, 4, 1987);
INSERT INTO public.autorstvi (id_autor, id_osoba, id_kniha, rok_napsani) VALUES (1, 1, 5, 2002);
INSERT INTO public.autorstvi (id_autor, id_osoba, id_kniha, rok_napsani) VALUES (2, 2, 3, 1937);
INSERT INTO public.autorstvi (id_autor, id_osoba, id_kniha, rok_napsani) VALUES (3, 3, 2, 1833);
INSERT INTO public.autorstvi (id_autor, id_osoba, id_kniha, rok_napsani) VALUES (4, 4, 1, 1877);
INSERT INTO public.autorstvi (id_autor, id_osoba, id_kniha, rok_napsani) VALUES (6, 6, 7, 1949);
INSERT INTO public.autorstvi (id_autor, id_osoba, id_kniha, rok_napsani) VALUES (7, 7, 6, 1845);
INSERT INTO public.autorstvi (id_autor, id_osoba, id_kniha, rok_napsani) VALUES (8, 8, 8, 2009);
INSERT INTO public.autorstvi (id_autor, id_osoba, id_kniha, rok_napsani) VALUES (8, 8, 9, 2011);
INSERT INTO public.autorstvi (id_autor, id_osoba, id_kniha, rok_napsani) VALUES (9, 30, 10, 1911);
INSERT INTO public.autorstvi (id_autor, id_osoba, id_kniha, rok_napsani) VALUES (10, 31, 11, 2007);
INSERT INTO public.autorstvi (id_autor, id_osoba, id_kniha, rok_napsani) VALUES (11, 32, 12, 1990);
INSERT INTO public.autorstvi (id_autor, id_osoba, id_kniha, rok_napsani) VALUES (12, 33, 12, 1990);
INSERT INTO public.autorstvi (id_autor, id_osoba, id_kniha, rok_napsani) VALUES (13, 37, 13, 1997);

INSERT INTO public.ctenar (id_ctenar, username, email, datum_registrace) VALUES (1, 'natalkazapalka2003', 'horii2003@dum.edu', '2020-07-26');
INSERT INTO public.ctenar (id_ctenar, username, email, datum_registrace) VALUES (2, 'anickatkanicka', 'botanicka@mail.cz', '2022-08-20');
INSERT INTO public.ctenar (id_ctenar, username, email, datum_registrace) VALUES (3, 'karel_barel', 'burger.k@kb.cz', '2021-01-01');

INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (1, 1, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (1, 2, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (1, 3, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (1, 4, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (1, 5, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (1, 6, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (1, 7, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (2, 4, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (2, 1, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (1, 8, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (1, 9, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (3, 9, 'rozecteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (3, 3, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (1, 10, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (1, 11, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (2, 10, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (3, 11, 'rozecteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (1, 12, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (2, 12, 'precteno');
INSERT INTO public.ctenarstvi (id_ctenar, id_kniha, stav_cteni) VALUES (1, 13, 'precteno');

INSERT INTO public.filmove_zpracovani (id_film, id_jazyk, id_kniha, nazev, reziser, rok_vydani) VALUES (1, 1, 1, 'Anna Karenina', 'Clarence Brown', 1935);
INSERT INTO public.filmove_zpracovani (id_film, id_jazyk, id_kniha, nazev, reziser, rok_vydani) VALUES (2, 1, 1, 'Anna Karenina', 'Joe Wright', 2012);
INSERT INTO public.filmove_zpracovani (id_film, id_jazyk, id_kniha, nazev, reziser, rok_vydani) VALUES (3, 1, 2, 'Evzen Onegin', 'Eva Sadkova', 1966);
INSERT INTO public.filmove_zpracovani (id_film, id_jazyk, id_kniha, nazev, reziser, rok_vydani) VALUES (5, 1, 3, 'Bila nemoc', 'Hugo Haas', 1937);
INSERT INTO public.filmove_zpracovani (id_film, id_jazyk, id_kniha, nazev, reziser, rok_vydani) VALUES (6, 3, 4, 'Norwegian Wood', 'Tran Anh Hung', 2010);
INSERT INTO public.filmove_zpracovani (id_film, id_jazyk, id_kniha, nazev, reziser, rok_vydani) VALUES (4, 2, 2, 'Evgenij Onegin', 'Roman Tichomirov', 1958);
INSERT INTO public.filmove_zpracovani (id_film, id_jazyk, id_kniha, nazev, reziser, rok_vydani) VALUES (7, 4, 7, 'Le Deuxieme Sexe', 'Caroline Sthene', 2008);
INSERT INTO public.filmove_zpracovani (id_film, id_jazyk, id_kniha, nazev, reziser, rok_vydani) VALUES (8, 3, 8, 'Heaven', 'Takahisa Zeze', 2022);
INSERT INTO public.filmove_zpracovani (id_film, id_jazyk, id_kniha, nazev, reziser, rok_vydani) VALUES (9, 5, 10, 'The Secret Garden', 'Fred M. Wilcox', 1949);
INSERT INTO public.filmove_zpracovani (id_film, id_jazyk, id_kniha, nazev, reziser, rok_vydani) VALUES (10, 1, 10, 'Tajna zahrada', 'Marc Munden', 2020);
INSERT INTO public.filmove_zpracovani (id_film, id_jazyk, id_kniha, nazev, reziser, rok_vydani) VALUES (11, 1, 12, 'Dobra znameni', 'Douglas Mackinnon', 2019);
INSERT INTO public.filmove_zpracovani (id_film, id_jazyk, id_kniha, nazev, reziser, rok_vydani) VALUES (12, 1, 13, 'Zoufale zeny delaji zoufale veci', 'Jitka Rudolfova', 2002);

INSERT INTO public.prvni_vydavatel (id_vyd, nazev) VALUES (1, 'Nakladatelstvi Zitra');
INSERT INTO public.prvni_vydavatel (id_vyd, nazev) VALUES (2, 'Russkij Vestnk');
INSERT INTO public.prvni_vydavatel (id_vyd, nazev) VALUES (3, 'A. Smirdin');
INSERT INTO public.prvni_vydavatel (id_vyd, nazev) VALUES (4, 'Fr. Borový');
INSERT INTO public.prvni_vydavatel (id_vyd, nazev) VALUES (5, 'Kodansha');
INSERT INTO public.prvni_vydavatel (id_vyd, nazev) VALUES (6, 'Shinchosha');
INSERT INTO public.prvni_vydavatel (id_vyd, nazev) VALUES (7, 'Wiley and Putnam');
INSERT INTO public.prvni_vydavatel (id_vyd, nazev) VALUES (8, 'Éditions Gallimard');
INSERT INTO public.prvni_vydavatel (id_vyd, nazev) VALUES (9, 'Frederick A. Stokes Company');
INSERT INTO public.prvni_vydavatel (id_vyd, nazev) VALUES (10, 'Hodder & Stoughton');
INSERT INTO public.prvni_vydavatel (id_vyd, nazev) VALUES (11, 'Gollancz ');
INSERT INTO public.prvni_vydavatel (id_vyd, nazev) VALUES (12, 'Nakladatelstvi XYZ');

INSERT INTO public.prvni_vydani (id_kniha, id_vyd, pocet_stran, rok_vydani) VALUES (1, 2, '864', 1875);
INSERT INTO public.prvni_vydani (id_kniha, id_vyd, pocet_stran, rok_vydani) VALUES (2, 3, '350', 1825);
INSERT INTO public.prvni_vydani (id_kniha, id_vyd, pocet_stran, rok_vydani) VALUES (3, 4, '92', 1937);
INSERT INTO public.prvni_vydani (id_kniha, id_vyd, pocet_stran, rok_vydani) VALUES (4, 5, '503', 1987);
INSERT INTO public.prvni_vydani (id_kniha, id_vyd, pocet_stran, rok_vydani) VALUES (5, 6, '576', 2002);
INSERT INTO public.prvni_vydani (id_kniha, id_vyd, pocet_stran, rok_vydani) VALUES (6, 7, '120', 1845);
INSERT INTO public.prvni_vydani (id_kniha, id_vyd, pocet_stran, rok_vydani) VALUES (7, 8, '800', 1949);
INSERT INTO public.prvni_vydani (id_kniha, id_vyd, pocet_stran, rok_vydani) VALUES (9, 5, '224', 2011);
INSERT INTO public.prvni_vydani (id_kniha, id_vyd, pocet_stran, rok_vydani) VALUES (8, 5, '192', 2009);
INSERT INTO public.prvni_vydani (id_kniha, id_vyd, pocet_stran, rok_vydani) VALUES (10, 9, '300', 1911);
INSERT INTO public.prvni_vydani (id_kniha, id_vyd, pocet_stran, rok_vydani) VALUES (11, 10, '400', 2007);
INSERT INTO public.prvni_vydani (id_kniha, id_vyd, pocet_stran, rok_vydani) VALUES (12, 11, '416', 1990);
INSERT INTO public.prvni_vydani (id_kniha, id_vyd, pocet_stran, rok_vydani) VALUES (13, 12, '224', 1997);

INSERT INTO public.znamy_clovek (id_zcl, id_osoba, status) VALUES (1, 11, 'zpevak');
INSERT INTO public.znamy_clovek (id_zcl, id_osoba, status) VALUES (3, 13, 'instagramovy podnikatel');
INSERT INTO public.znamy_clovek (id_zcl, id_osoba, status) VALUES (2, 12, 'znamy finacni poradce');

INSERT INTO public.literarni_kritik (id_kritik, id_osoba, vybiravy) VALUES (1, 14, 'velmi');
INSERT INTO public.literarni_kritik (id_kritik, id_osoba, vybiravy) VALUES (2, 15, 'spise liny');


INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (1, 1, null, null, 10, '2021-05-14');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (1, 2, null, null, 4, '2023-08-18');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (1, null, 1, 14, 1, '2019-06-19');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (2, null, 1, 14, 1, '2009-09-17');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (3, null, 1, 14, 3, '2016-03-10');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (4, null, 1, 14, 1, '2018-05-01');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (5, null, 1, 14, 4, '2006-11-11');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (6, null, 1, 14, 2, '2020-08-16');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (7, null, 1, 14, 1, '2004-03-03');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (8, null, 1, 14, 1, '2021-07-17');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (9, null, 1, 14, 1, '2024-09-20');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (10, null, 1, 14, 2, '2022-07-09');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (11, null, 1, 14, 3, '2024-08-16');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (3, null, 2, 15, 9, '2016-02-12');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (1, null, 2, 15, 10, '2021-06-14');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (12, null, 1, 14, 1, '2000-12-15');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (12, 2, null, null, 10, '2019-10-18');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (13, null, 1, 14, 0, '2000-11-11');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (13, 1, null, null, 7, '2024-12-21');
INSERT INTO public.recenze (id_kniha, id_ctenar, id_kritik, id_osoba, body, datum) VALUES (13, null, 2, 15, 10, '2010-05-05');

INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (1, 16, 'Ceska');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (2, 17, 'Cech');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (3, 18, 'Cech');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (4, 19, 'Cech');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (5, 20, 'Ceska');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (6, 21, 'Cech');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (7, 22, 'Ceska');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (8, 23, 'Cech');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (9, 24, 'Cech');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (10, 25, 'American');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (11, 26, 'American');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (12, 27, 'Brit');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (13, 28, 'Rakusan');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (14, 29, 'Rus');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (15, 34, 'Nemec');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (16, 35, 'Cech');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (17, 36, 'Francouz');
INSERT INTO public.prekladatel (id_prekladatel, id_osoba, narodnost) VALUES (18, 38, 'Polka');

INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (1, 7, 1, 16, 1966);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (1, 7, 2, 17, 1966);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (1, 6, 3, 18, 1926);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (1, 8, 4, 19, 2023);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (1, 8, 5, 20, 2023);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (1, 5, 6, 21, 2006);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (1, 4, 7, 22, 2008);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (1, 2, 8, 23, 1961);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (1, 1, 9, 24, 1955);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (5, 9, 10, 25, 2022);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (5, 9, 11, 26, 2022);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (5, 3, 12, 27, 1937);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (4, 3, 13, 28, 1937);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (2, 3, 14, 29, 1937);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (6, 12, 15, 34, 1991);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (1, 12, 16, 35, 2001);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (4, 12, 17, 36, 1991);
INSERT INTO public.preklad (id_jazyk, id_kniha, id_prekladatel, id_osoba, rok_prekladu) VALUES (7, 13, 18, 38, 2002);

INSERT INTO public.krest_knihy (id_krtu, id_kniha, misto_krestu, datum_krestu) VALUES (1, 3, 'Praha', null);
INSERT INTO public.krest_knihy (id_krtu, id_kniha, misto_krestu, datum_krestu) VALUES (3, 4, 'Kanagawa', null);
INSERT INTO public.krest_knihy (id_krtu, id_kniha, misto_krestu, datum_krestu) VALUES (2, 5, 'Tokyo', '2002-08-23');

INSERT INTO public.kmotr_knihy (id_krtu, id_kniha, id_osoba, vztah_k_autorovi) VALUES (1, 3, 2, '');
INSERT INTO public.kmotr_knihy (id_krtu, id_kniha, id_osoba, vztah_k_autorovi) VALUES (2, 5, 9, 'znamy');
INSERT INTO public.kmotr_knihy (id_krtu, id_kniha, id_osoba, vztah_k_autorovi) VALUES (3, 4, 10, 'neznamy');

INSERT INTO public.navsteva_krtu (id_krtu, id_kniha, id_osoba) VALUES (2, 5, 12);
INSERT INTO public.navsteva_krtu (id_krtu, id_kniha, id_osoba) VALUES (2, 5, 11);
INSERT INTO public.navsteva_krtu (id_krtu, id_kniha, id_osoba) VALUES (1, 3, 11);
INSERT INTO public.navsteva_krtu (id_krtu, id_kniha, id_osoba) VALUES (3, 4, 11);
INSERT INTO public.navsteva_krtu (id_krtu, id_kniha, id_osoba) VALUES (1, 3, 13);
INSERT INTO public.navsteva_krtu (id_krtu, id_kniha, id_osoba) VALUES (3, 4, 13);
