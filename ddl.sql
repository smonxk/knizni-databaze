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
-- End of removing

CREATE TABLE autor (
    id_autor SERIAL NOT NULL,
    id_osoba INTEGER NOT NULL,
    narozeni DATE NOT NULL,
    smrt DATE,
    narodnost VARCHAR(256) NOT NULL
);
ALTER TABLE autor ADD CONSTRAINT pk_autor PRIMARY KEY (id_autor, id_osoba);
ALTER TABLE autor ADD CONSTRAINT u_fk_autor_osoba UNIQUE (id_osoba);

CREATE TABLE autor_oceneni (
    id_autor INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL,
    id_oceneni INTEGER NOT NULL,
    rok INTEGER NOT NULL
);
ALTER TABLE autor_oceneni ADD CONSTRAINT pk_autor_oceneni PRIMARY KEY (id_autor, id_osoba, id_oceneni);

CREATE TABLE autorsmer (
    id_autor INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL,
    id_litsmer INTEGER NOT NULL,
    datum_zacleneni DATE NOT NULL
);
ALTER TABLE autorsmer ADD CONSTRAINT pk_autorsmer PRIMARY KEY (id_autor, id_osoba, id_litsmer);

CREATE TABLE autorstvi (
    id_autor INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL,
    id_kniha INTEGER NOT NULL,
    rok_napsani INTEGER NOT NULL
);
ALTER TABLE autorstvi ADD CONSTRAINT pk_autorstvi PRIMARY KEY (id_autor, id_osoba, id_kniha);

CREATE TABLE ctenar (
    id_ctenar SERIAL NOT NULL,
    username VARCHAR(256) NOT NULL,
    email VARCHAR(256) NOT NULL,
    datum_registrace DATE NOT NULL
);
ALTER TABLE ctenar ADD CONSTRAINT pk_ctenar PRIMARY KEY (id_ctenar);
ALTER TABLE ctenar ADD CONSTRAINT uc_ctenar_email UNIQUE (email);

CREATE TABLE ctenarstvi (
    id_ctenar INTEGER NOT NULL,
    id_kniha INTEGER NOT NULL,
    stav_cteni VARCHAR(256) NOT NULL
);
ALTER TABLE ctenarstvi ADD CONSTRAINT pk_ctenarstvi PRIMARY KEY (id_ctenar, id_kniha);

CREATE TABLE filmove_zpracovani (
    id_film SERIAL NOT NULL,
    id_jazyk INTEGER NOT NULL,
    id_kniha INTEGER NOT NULL,
    nazev VARCHAR(256) NOT NULL,
    reziser VARCHAR(256) NOT NULL,
    rok_vydani INTEGER NOT NULL
);
ALTER TABLE filmove_zpracovani ADD CONSTRAINT pk_filmove_zpracovani PRIMARY KEY (id_film);

CREATE TABLE jazyk (
    id_jazyk SERIAL NOT NULL,
    nazev VARCHAR(256) NOT NULL
);
ALTER TABLE jazyk ADD CONSTRAINT pk_jazyk PRIMARY KEY (id_jazyk);

CREATE TABLE kmotr_knihy (
    id_krtu INTEGER NOT NULL,
    id_kniha INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL,
    vztah_k_autorovi VARCHAR(256)
);
ALTER TABLE kmotr_knihy ADD CONSTRAINT pk_kmotr_knihy PRIMARY KEY (id_krtu, id_kniha, id_osoba);
ALTER TABLE kmotr_knihy ADD CONSTRAINT u_fk_kmotr_knihy_krest_knihy UNIQUE (id_krtu, id_kniha);
ALTER TABLE kmotr_knihy ADD CONSTRAINT u_fk_kmotr_knihy_osoba UNIQUE (id_osoba);

CREATE TABLE kniha (
    id_kniha SERIAL NOT NULL,
    id_jazyk INTEGER NOT NULL,
    id_litsmer INTEGER NOT NULL,
    nazev VARCHAR(256) NOT NULL,
    isbn BIGINT NOT NULL
);
ALTER TABLE kniha ADD CONSTRAINT pk_kniha PRIMARY KEY (id_kniha);
ALTER TABLE kniha ADD CONSTRAINT uc_kniha_isbn UNIQUE (isbn);

CREATE TABLE krest_knihy (
    id_krtu SERIAL NOT NULL,
    id_kniha INTEGER NOT NULL,
    misto_krestu VARCHAR(256),
    datum_krestu DATE
);
ALTER TABLE krest_knihy ADD CONSTRAINT pk_krest_knihy PRIMARY KEY (id_krtu, id_kniha);
ALTER TABLE krest_knihy ADD CONSTRAINT u_fk_krest_knihy_kniha UNIQUE (id_kniha);

CREATE TABLE lit_smer (
    id_litsmer SERIAL NOT NULL,
    nazev VARCHAR(256) NOT NULL,
    datum_vzniku DATE NOT NULL
);
ALTER TABLE lit_smer ADD CONSTRAINT pk_lit_smer PRIMARY KEY (id_litsmer);
ALTER TABLE lit_smer ADD CONSTRAINT uc_lit_smer_nazev UNIQUE (nazev);

CREATE TABLE literarni_kritik (
    id_kritik SERIAL NOT NULL,
    id_osoba INTEGER NOT NULL,
    vybiravy VARCHAR(256) NOT NULL
);
ALTER TABLE literarni_kritik ADD CONSTRAINT pk_literarni_kritik PRIMARY KEY (id_kritik, id_osoba);
ALTER TABLE literarni_kritik ADD CONSTRAINT u_fk_literarni_kritik_osoba UNIQUE (id_osoba);

CREATE TABLE literarni_oceneni (
    id_oceneni SERIAL NOT NULL,
    nazev VARCHAR(256) NOT NULL
);
ALTER TABLE literarni_oceneni ADD CONSTRAINT pk_literarni_oceneni PRIMARY KEY (id_oceneni);
ALTER TABLE literarni_oceneni ADD CONSTRAINT uc_literarni_oceneni_nazev UNIQUE (nazev);

CREATE TABLE navsteva_krtu (
    id_krtu INTEGER NOT NULL,
    id_kniha INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL
);
ALTER TABLE navsteva_krtu ADD CONSTRAINT pk_navsteva_krtu PRIMARY KEY (id_krtu, id_kniha, id_osoba);

CREATE TABLE osoba (
    id_osoba SERIAL NOT NULL,
    jmeno VARCHAR(256) NOT NULL,
    prijmeni VARCHAR(256) NOT NULL
);
ALTER TABLE osoba ADD CONSTRAINT pk_osoba PRIMARY KEY (id_osoba);

CREATE TABLE preklad (
    id_jazyk INTEGER NOT NULL,
    id_kniha INTEGER NOT NULL,
    id_prekladatel INTEGER NOT NULL,
    id_osoba INTEGER NOT NULL,
    rok_prekladu INTEGER NOT NULL
);
ALTER TABLE preklad ADD CONSTRAINT pk_preklad PRIMARY KEY (id_jazyk, id_kniha, id_prekladatel, id_osoba);

CREATE TABLE prekladatel (
    id_prekladatel SERIAL NOT NULL,
    id_osoba INTEGER NOT NULL,
    narodnost VARCHAR(256) NOT NULL
);
ALTER TABLE prekladatel ADD CONSTRAINT pk_prekladatel PRIMARY KEY (id_prekladatel, id_osoba);
ALTER TABLE prekladatel ADD CONSTRAINT u_fk_prekladatel_osoba UNIQUE (id_osoba);

CREATE TABLE prvni_vydani (
    id_kniha INTEGER NOT NULL,
    id_vyd INTEGER NOT NULL,
    pocet_stran VARCHAR(256),
    rok_vydani INTEGER NOT NULL
);
ALTER TABLE prvni_vydani ADD CONSTRAINT pk_prvni_vydani PRIMARY KEY (id_kniha, id_vyd);
ALTER TABLE prvni_vydani ADD CONSTRAINT u_fk_prvni_vydani_kniha UNIQUE (id_kniha);

CREATE TABLE prvni_vydavatel (
    id_vyd SERIAL NOT NULL,
    nazev VARCHAR(256) NOT NULL
);
ALTER TABLE prvni_vydavatel ADD CONSTRAINT pk_prvni_vydavatel PRIMARY KEY (id_vyd);
ALTER TABLE prvni_vydavatel ADD CONSTRAINT uc_prvni_vydavatel_nazev UNIQUE (nazev);

CREATE TABLE recenze (
    id_kniha INTEGER NOT NULL,
    id_ctenar INTEGER,
    id_kritik INTEGER,
    id_osoba INTEGER,
    body INTEGER NOT NULL,
    datum DATE NOT NULL
);
ALTER TABLE recenze ADD CONSTRAINT pk_recenze PRIMARY KEY (id_kniha);
ALTER TABLE recenze ADD CONSTRAINT c_fk_recenze_literarni_kritik CHECK ((id_kritik IS NOT NULL AND id_osoba IS NOT NULL) OR (id_kritik IS NULL AND id_osoba IS NULL));

CREATE TABLE znamy_clovek (
    id_zcl SERIAL NOT NULL,
    id_osoba INTEGER NOT NULL,
    status VARCHAR(256)
);
ALTER TABLE znamy_clovek ADD CONSTRAINT pk_znamy_clovek PRIMARY KEY (id_zcl, id_osoba);
ALTER TABLE znamy_clovek ADD CONSTRAINT u_fk_znamy_clovek_osoba UNIQUE (id_osoba);

ALTER TABLE autor ADD CONSTRAINT fk_autor_osoba FOREIGN KEY (id_osoba) REFERENCES osoba (id_osoba) ON DELETE CASCADE;

ALTER TABLE autor_oceneni ADD CONSTRAINT fk_autor_oceneni_autor FOREIGN KEY (id_autor, id_osoba) REFERENCES autor (id_autor, id_osoba) ON DELETE CASCADE;
ALTER TABLE autor_oceneni ADD CONSTRAINT fk_autor_oceneni_literarni_ocen FOREIGN KEY (id_oceneni) REFERENCES literarni_oceneni (id_oceneni) ON DELETE CASCADE;

ALTER TABLE autorsmer ADD CONSTRAINT fk_autorsmer_autor FOREIGN KEY (id_autor, id_osoba) REFERENCES autor (id_autor, id_osoba) ON DELETE CASCADE;
ALTER TABLE autorsmer ADD CONSTRAINT fk_autorsmer_lit_smer FOREIGN KEY (id_litsmer) REFERENCES lit_smer (id_litsmer) ON DELETE CASCADE;

ALTER TABLE autorstvi ADD CONSTRAINT fk_autorstvi_autor FOREIGN KEY (id_autor, id_osoba) REFERENCES autor (id_autor, id_osoba) ON DELETE CASCADE;
ALTER TABLE autorstvi ADD CONSTRAINT fk_autorstvi_kniha FOREIGN KEY (id_kniha) REFERENCES kniha (id_kniha) ON DELETE CASCADE;

ALTER TABLE ctenarstvi ADD CONSTRAINT fk_ctenarstvi_ctenar FOREIGN KEY (id_ctenar) REFERENCES ctenar (id_ctenar) ON DELETE CASCADE;
ALTER TABLE ctenarstvi ADD CONSTRAINT fk_ctenarstvi_kniha FOREIGN KEY (id_kniha) REFERENCES kniha (id_kniha) ON DELETE CASCADE;

ALTER TABLE filmove_zpracovani ADD CONSTRAINT fk_filmove_zpracovani_jazyk FOREIGN KEY (id_jazyk) REFERENCES jazyk (id_jazyk) ON DELETE CASCADE;
ALTER TABLE filmove_zpracovani ADD CONSTRAINT fk_filmove_zpracovani_kniha FOREIGN KEY (id_kniha) REFERENCES kniha (id_kniha) ON DELETE CASCADE;

ALTER TABLE kmotr_knihy ADD CONSTRAINT fk_kmotr_knihy_krest_knihy FOREIGN KEY (id_krtu, id_kniha) REFERENCES krest_knihy (id_krtu, id_kniha) ON DELETE CASCADE;
ALTER TABLE kmotr_knihy ADD CONSTRAINT fk_kmotr_knihy_osoba FOREIGN KEY (id_osoba) REFERENCES osoba (id_osoba) ON DELETE CASCADE;

ALTER TABLE kniha ADD CONSTRAINT fk_kniha_jazyk FOREIGN KEY (id_jazyk) REFERENCES jazyk (id_jazyk) ON DELETE CASCADE;
ALTER TABLE kniha ADD CONSTRAINT fk_kniha_lit_smer FOREIGN KEY (id_litsmer) REFERENCES lit_smer (id_litsmer) ON DELETE CASCADE;

ALTER TABLE krest_knihy ADD CONSTRAINT fk_krest_knihy_kniha FOREIGN KEY (id_kniha) REFERENCES kniha (id_kniha) ON DELETE CASCADE;

ALTER TABLE literarni_kritik ADD CONSTRAINT fk_literarni_kritik_osoba FOREIGN KEY (id_osoba) REFERENCES osoba (id_osoba) ON DELETE CASCADE;

ALTER TABLE navsteva_krtu ADD CONSTRAINT fk_navsteva_krtu_krest_knihy FOREIGN KEY (id_krtu, id_kniha) REFERENCES krest_knihy (id_krtu, id_kniha) ON DELETE CASCADE;
ALTER TABLE navsteva_krtu ADD CONSTRAINT fk_navsteva_krtu_osoba FOREIGN KEY (id_osoba) REFERENCES osoba (id_osoba) ON DELETE CASCADE;

ALTER TABLE preklad ADD CONSTRAINT fk_preklad_jazyk FOREIGN KEY (id_jazyk) REFERENCES jazyk (id_jazyk) ON DELETE CASCADE;
ALTER TABLE preklad ADD CONSTRAINT fk_preklad_kniha FOREIGN KEY (id_kniha) REFERENCES kniha (id_kniha) ON DELETE CASCADE;
ALTER TABLE preklad ADD CONSTRAINT fk_preklad_prekladatel FOREIGN KEY (id_prekladatel, id_osoba) REFERENCES prekladatel (id_prekladatel, id_osoba) ON DELETE CASCADE;

ALTER TABLE prekladatel ADD CONSTRAINT fk_prekladatel_osoba FOREIGN KEY (id_osoba) REFERENCES osoba (id_osoba) ON DELETE CASCADE;

ALTER TABLE prvni_vydani ADD CONSTRAINT fk_prvni_vydani_kniha FOREIGN KEY (id_kniha) REFERENCES kniha (id_kniha) ON DELETE CASCADE;
ALTER TABLE prvni_vydani ADD CONSTRAINT fk_prvni_vydani_prvni_vydavatel FOREIGN KEY (id_vyd) REFERENCES prvni_vydavatel (id_vyd) ON DELETE CASCADE;

ALTER TABLE recenze ADD CONSTRAINT fk_recenze_kniha FOREIGN KEY (id_kniha) REFERENCES kniha (id_kniha) ON DELETE CASCADE;
ALTER TABLE recenze ADD CONSTRAINT fk_recenze_ctenar FOREIGN KEY (id_ctenar) REFERENCES ctenar (id_ctenar) ON DELETE CASCADE;
ALTER TABLE recenze ADD CONSTRAINT fk_recenze_literarni_kritik FOREIGN KEY (id_kritik, id_osoba) REFERENCES literarni_kritik (id_kritik, id_osoba) ON DELETE CASCADE;

ALTER TABLE znamy_clovek ADD CONSTRAINT fk_znamy_clovek_osoba FOREIGN KEY (id_osoba) REFERENCES osoba (id_osoba) ON DELETE CASCADE;

ALTER TABLE recenze ADD CONSTRAINT xc_recenze_id_ctenar_id_kritik CHECK ((id_ctenar IS NOT NULL AND id_kritik IS NULL) OR (id_ctenar IS NULL AND id_kritik IS NOT NULL));

