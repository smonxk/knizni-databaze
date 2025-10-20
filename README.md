# Popis projektu
Tato databáze je projekt, jehož cílem je shromažďování a spravování informací o autorech a jejich dílech, překladech a recenzích. Částečně se tato databáze zabývá i čtenáři.
Literární databáze byla navržena s úsmyslem usnadnit práci studentům, čtenářům, nebo dokonce i odborníkům v oblasti literatury.Je zde několik entit, ale středem zájmu uživatele
pravděpodobně budou entity "Kniha" a "Autor", popřípadě "První vydavatel" (pro zjednodušení databáze pracuji pouze s prvním vydavatelem). Každá entita obsahuje podrobnější data,
atributy, které mohou uživateli usnadnit jeho práci a zároveň tyto atributy přispívají lepší organizaci a klasifikaci literárních děl. Například u knihy jsou atributy "název" a
unikátní atribut "ISBN" (existenci duplikátních ISBN neberu v tomto projektu v potaz). Dalšími zajímavými entitami jsou "Čtenář" a "Překladatel". "Čtenář" je v tomto ohledu brán
jako uživatel literárního portálu (např. Goodreads), proto má nepovinný atribut jméno, ale naopak povinným atributem je jeho username. Databáze také zahrnuje uložení recenzí, 
respektive jejich bodů, takže umožňuje čtenářům odhalit, která kniha se těší jaké oblibě. Tyto recenze může psát "Čtenář" nebo "Literární kritik". K lepšímu porozumění kontextu,
ve kterém knihy vznikly, se v databázi také nachází entity "Literární směr" a "Jazyk". Díky těmto entitám lze například porovnávat literární díla v rámci různých historických
kontextů nebo národních kontextů.Tuto databázi jsem chtěla vytvořit tak, aby se z ní stal užitečný nástroj pro orientaci v literárním světě. Inspirací mi byly čtenářské deníky
a portál Goodreads.

## Příklady smyček a jejich diskuze
### Smyčka Autor - Autorstvi - Kniha - Lit_Smer - Autorsmer - Autor
Autor se podílí na literárním směru svou tvorbou. Pokud by měla databáze špatné údaje, mohlo by se stát, že se autor stane autorem knihy ve špatném směru.Takové situaci by měla
zabránit tabulka Autorsmer. Smyčka Kniha - Filmove_Zpracovani - Jazyk - Kniha Kniha se pojí ke svému filmovému zpracování, to má specifikovaný jazyk, přes jazyk se lze vrátit k
filmu. Tento databázový systém nepožaduje, aby kniha a její filmové zpracování byly ve stejném jazyce. Smyčka Kniha - Kmotr_knihy - Krest_knihy - Kniha Zde by mohl nastat problém,
kdyby kniha byla spojena s křestem, který nemá kmotra (ten by byl povinným účastníkem). V tomto modelu není kmotr povinnou vazbou, smyčka by proto neměla být problémem.

### Smyčka Jazyk - Preklad - Kniha - Jazyk Smyčka propojuje jazyk, překlad a knihu. Každý překlad je spojen s knihou a zároveň odkazuje na jazyk překladu. Kniha může být napsána v
jiném jazyce, než ve kterém je překlad vytvořen. Pokud by databáze obsahovala chybná data, mohla by být nesprávně propojena kniha a její překlad, například nesoulad mezi jazykem
překladu a jazykem knihy. To by vedlo k nekonzistenci v evidenci jazyků. To je ovšem zálěžitost aplikace nad databází / toho, kdo data vkládá.

### Smyčka Kniha - Jazyk - Preklad - Prekladatel - Osoba - Autor - Autorstvi - Kniha
Mohlo by se stát, že autor bude překládat vlastní knihu. To je v pořádku.

### Smyčka Kmotr_Knihy - Kniha - Autor - Osoba - Kmotr_knihy
Mohlo by se stát, že kmotr bude zároveň autorem, což nevadí.

### Literární Kritik - Osoba - Prekladatel - Preklad - Jazyk - Kniha - Autor - Osoba - Literarni kritik
Není problémem, že by jedna osoba byla zároveň překladatelem, autorem a literárním kritikem. Nicméně by se mohlo stát, že by literární kritik hodnotil svůj překlad, což mi nedávalo
moc smysl; proto jsem omezila tuto možnost skrz IO, XORem (zároveň si myslím, že je potřeba odlišného myšlení pro literárního kritika a pro překladatele). Autor by mohl kritizovat
vlastní knihu, což je smysluplné ve formě sebereflexe.

---

# Project Description
This database is a project aimed at collecting and managing information about authors and their works, translations, and reviews. It also partially deals with readers.
The literary database was designed with the intention of making the work of students, readers, and even literary professionals easier. There are several entities in the database,
but the main focus for users will likely be the entities Kniha and Autor, possibly also První_vydavatel (for simplicity, the database works only with the first publisher). Each
entity contains more detailed data—attributes that can help users with their tasks and also contribute to better organization and classification of literary works. For example, 
the entity Kniha includes attributes such as "title" and the unique attribute "ISBN" (duplicate ISBNs are not considered in this project). Other interesting entities include Čtenář
and Překladatel. Čtenář is considered a user of a literary portal (e.g., Goodreads), and therefore has an optional attribute for their name, but a mandatory attribute for their
username. The database also includes the storage of reviews and their scores, allowing readers to identify which books are more or less popular. These reviews can be written by
either a Čtenář or a Literární_kritik. To better understand the context in which books were written, the database also includes the entities Literární_směr and Jazyk. Thanks
to these entities, it is possible to compare literary works within various historical or national contexts.I wanted to design this database to become a useful tool for navigating
the literary world. I was inspired by reading journals and the Goodreads platform.

## Examples of Loops and Their Discussion
###Loop: Autor – Autorstvi – Kniha – Lit_Smer – Autorsmer – Autor
An author contributes to a literary movement through their work. If the database contained incorrect data, it might happen that an author would be linked to a book in the wrong
literary movement. This kind of issue should be prevented by the Autorsmer table.

### Loop: Kniha – Filmove_Zpracovani – Jazyk – Kniha
A book is connected to its film adaptation, which specifies a language. Through the language, it is possible to trace back to the film. This database system does not require the
book and its film adaptation to be in the same language.

### Loop: Kniha – Kmotr_knihy – Krest_knihy – Kniha
A potential issue might occur if a book is linked to a book launch (Krest_knihy) that doesn't have a godparent (Kmotr_knihy), who should be a mandatory participant. However, in 
this model, a godparent is not a required link, so this loop should not pose a problem.

### Loop: Jazyk – Preklad – Kniha – Jazyk
This loop connects language, translation, and book. Each translation is linked to a book and at the same time refers to the language of the translation. A book may be written in a
different language than the one used in the translation. If the database contained incorrect data, it could incorrectly link a book and its translation—for example, a mismatch
between the translation language and the book’s original language. This would lead to inconsistency in language records. However, such issues fall under the responsibility of the
application layer or the person entering the data.

### Loop: Kniha – Jazyk – Preklad – Prekladatel – Osoba – Autor – Autorstvi – Kniha
It might happen that an author translates their own book. This is acceptable.

### Loop: Kmotr_knihy – Kniha – Autor – Osoba – Kmotr_knihy
It is possible that the godparent is also the author, which is not a problem.

### Loop: Literární_kritik – Osoba – Prekladatel – Preklad – Jazyk – Kniha – Autor – Osoba – Literární_kritik
There is no issue if one person is at the same time a translator, author, and literary critic. However, it could happen that a literary critic evaluates their own translation, 
which didn't make much sense to me; therefore, I restricted this possibility through an IO or XOR constraint (also, I believe that being a literary critic and a translator requires
different mindsets). On the other hand, it is meaningful for an author to critique their own work as a form of self-reflection.

---

# Diagram
<img width="2676" height="997" alt="diagram" src="https://github.com/user-attachments/assets/90a088b4-d34c-4bcf-af3b-6f69a6813d0e" />
<img width="2676" height="997" alt="diagram (1)" src="https://github.com/user-attachments/assets/73dd85c9-0c45-4ce7-b725-9a0ffe51bd9f" />
<img width="2676" height="997" alt="diagram (2)" src="https://github.com/user-attachments/assets/baa6cda4-989e-4679-913a-b5f3c583a099" />
