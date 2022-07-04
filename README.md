# ✏️ Let's Vote! 🗳

## Progetto di Sistemi Distribuiti

### Appello: 
Terzo appello, Sessione Estiva 2021/2022

### Studenti: 
* [Andrea De Luna](https://github.com/andreadeluna), **Matricola :** 313076

* [Veronica Michelini](https://github.com/VeronicaMichelini), **Matricola :** 317197 
  
* [Ani Yeganyan](https://github.com/yeganyan-ani), **Matricola :** 

-----------------------------------------------------

## Obiettivo
Il progetto consiste nell'implementazione di un'applicazione decentrallizzata (DApp) di votazione, che esegue le funzioni di uno smart contract attraverso un'interfaccia utente. Si tratta dunque di un'applicazione il cui funzionamento non dipende da punti di controllo o da server centrali, ma che funziona sulla base di una rete decentralizzata, in cui gli utenti hanno il pieno controllo del suo funzionamento e possono accedere ai diversi servizi in modo sicuro.  
In particolare, la differenza principale tra un'applicazione di questo tipo e quelle centralizzate è che le DApp girano su una blockchain o su un network di computer peer-to-peer (P2P), invece che su un singolo computer.  
L'accettazione o meno delle operazioni effettuate dagli utenti della DApp è subordinata alla programmazione dello "smart contract", che cerca di garantire che tutti i partecipanti agiscano nel quadro da esso specificato.  
Anche l'applicazione di voto in questione quindi, può operare in modo autonomo grazie all'uso di uno smart contract, ovvero codice scritto sulla blockchain
e che quindi una volta implementato non può essere modificato in modo semplice.  
Nello smart contract realizzato per l'applicazione sono presenti:
* Un amministratore (proprietario dell'elezione), che ha il compito di distribuire il contratto, autorizza gli elettori a votare ed inserisce nuovi candidati alla lista.
* Degli elettori, che possono votare un candidato una volta che il contratto è stato distribuito.

-----------------------------------------------------

## Creazione di un portafoglio Metamask
Per interagire con la DApp della blockchain di Ethereum è stato utilizzato il plug-in per browser MetaMask, in quanto funge da ponte tra DApp e browser web grazie a web3.js, una libreria che fa parte dello sviluppo ufficiale di Ethereum, nata per consentire la creazione di applicazioni web che potessero interagire con la blockchain di Ethereum stesso.  
MetaMask è quindi un portafoglio per Ethereum e uno strumento per interagire con le DApps. Per fare ciò stabilisce un canale di comunicazione tra l'estensione e la DApp in questione.  
Una volta che l'applicazione riconosce la presenza di MetaMask esso viene abilitato, ed è possibile eseguire tutte le azioni o gli eventi che permette di svolgere.  
Tutte le azioni che si compiono devono essere pagate in termini di "commissioni di gas" ai miners, in modo che essi possano verificare ed accettare le transazioni che si vogliono effettuare.
A tale scopo è stato necessario collegarsi ad una rete di test (Goerli), in modo da non utilizzare soldi reali per le transazioni. Successivamente, si sono dovuti scaricare degli "Ethereum di test" dal sito "https://goerlifaucet.com/", in modo da poter eseguire le operazioni necessarie durante l'utilizzo dell'API.  
Su Metamask abbiamo utilizzato due account: 

* Account dell'amministratore: colui che sta creando o implementando lo smart contract.
* Account dell'elettore: colui che una volta autorizzato può esprimere il suo voto.

Le chiavi private del proprietario e dell'elettore sono poi state definite nel file "costanti.dart". Esse sono necessarie perchè ogni volta che si usa una funzione vengono addebitate le "spese del gas", ossia le commissioni sulla transazione, e per pagare queste spese serve la chiave privata, altrimenti chiunque potrebbe usare la chiave pubblica di qualcun altro per pagare le commissioni. Quindi servono le chiavi private per firmare il contratto.

-----------------------------------------------------

## Creazione dello smart contract
I contratti sono regole che consentono, a tutte le parti che lo accettano, di capire in cosa consisterà l'interazione che intendono effettuare.  
Uno smart contract è in grado di realizzarsi e di farsi rispettare in modo autonomo e automatico, senza intermediari e senza dipendere da un'autorità centrale.  
Non essendo verbale, né scritto in nessuna delle lingue che parliamo, evita il problema dell'interpretazione personale.  
È un codice visibile a tutti, che non può essere modificato in quanto presente sulla tecnologia blockchain. 
Gli smart contract sono infatti degli "script" (codice informatici) scritti con linguaggi di programmazione, visibile a tutti e che non può essere modificato in quanto presente sulla tecnologia blockchain.  
Il linguaggio di programmazione utilizzato per scrivere lo smart contract è Solidity, progettato specificamente per sviluppare applicazioni per la rete Ethereum.  
Grazie a EVM e Solidity è possibile programmare azioni che verranno poi eseguite da EVM in modo decentralizzato sulla rete Ethereum, e questo implica che deve essere predisposto un meccanismo di protezione per prevenirne l'uso improprio. Questo meccanismo è noto come "Gas" e serve per evitare che il sistema venga bloccato dalla creazione di loop infiniti o altre azioni dannose.

Come prima cosa è stata definita la licenza e la versione di solidity.  
Il contratto contiene al suo interno :
* La struttura che definisce "Candidato"
  * Nome candidato
  * Partito di appartenenza
  * Descrizione del candidato
  * Numero voti che il candidato ha ottenuto
<p align="center">
	<img src="https://user-images.githubusercontent.com/44511696/177215074-15c805de-35f1-4976-8a53-ce22080eea4f.png" width="200" height="100">
</p>

* La struttura che definisce "Elettore"
  * Nome dell'elettore
  * Booleano per determinare se l'elettore è autorizzato a votare
  * Indice della lista dei candidati, che corrisponde alla posizione del candidato che l'elettore vuole votare
  * Booleano per verificare se l'elettore ha già votato oppure no
<p align="center">
	<img src="https://user-images.githubusercontent.com/44511696/177217996-5f307434-5907-42c0-a68f-5de7664e3806.png" width="200" height="100">
</p>

* L'indirizzo del propietario dello smart contract. Questo indirizzo è pubblico, in modo che tutti possano vedere chi è il proprietario dello smart contract
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996728-57227b75-ae0b-406b-a54e-d262a6af3685.png" width="250" height="30">
</p>

* Stringa pubblica per il Nome/Titolo della votazione, in modo che tutti possano verificare per quale votazione stanno votando
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996737-b24124bd-6f3e-426e-83c7-fddee4559c28.png" width="250" height=30">
</p>
																	       
* Mappatura dell'indirizzo a un elettore. Ogni indirizzo avrà la struttura dell'elettore
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996731-43a2dd6b-e823-4afa-94d2-8089ccdbfe7c.png" width="300" height="30">
</p>
																		
* Lista che contiene l'elenco di tutti i candidati della relativa votazione
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996696-7a602cd9-5d59-450f-b57d-b2660152f408.png" width="280" height="30">
</p>
																		
* Variabile che contiene il numero totale di voti di tutta la votazione
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996749-e242806a-2f86-425e-9e74-8b83a64084e9.png" width="230" height="30">
</p>
																		
* Modificatore per permettere solo al proprietario dello smart contract di aggiungere nuovi candidati
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996733-470ec2af-b5d0-48d2-b441-10b691d525bc.png" width="350" height=100">
</p>

Definizione delle funzioni principali
* Funzione pubblica per l'avvio della votazione. Prende come parametro di input il nome della votazione.  
La persona che ha distribuito o creato il contratto diventerà il proprietario dell'elezione.
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996712-8b6a9a01-9152-466d-b09c-9f1669372388.png" width="500" height="100">
</p>

* Funzione per l'aggiunta di un nuovo candidato alla lista dei candidati. Prende come parametro di input il nome del nuovo candidato da aggiungere, il partito di appartenenza e la descrizione.  
Questa funzione può essere richiamata solo dal proprietario dello smart contract.  
  * Per effettuare questa verifica si richiama il modificatore creato a tale scopo.
  * Il nuovo candidato viene inizializzato con il nome che è stato passato come parametro e numero di voti pari a 0.
<p align="center">
	<img src="https://user-images.githubusercontent.com/44511696/177216369-d7277364-188c-42df-bd36-1381f0dd4997.png" width=500" height="120">
</p>
																		
* Funzione per autorizzare il voto. Prende come parametro di input l'indirizzo dell'elettore che sta votando.
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996702-579a234f-f16e-46e5-8a69-00824f4d4aba.png" width="550" height="80">
</p>
																		
* Funzione per ottenere il numero totale di Candidati presenti nella votazione.
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996716-142769d4-0e4b-4ac2-a08d-278d1e5b24d5.png" width="500" height="80">
</p>
																		
* Funzione per effettuare la votazione. Prende come parametro l'indice del Candidato che si vuole votare.
  * Verifica che l'elettore non abbia già votato. Se il relativo valore booleano è falso l'elettore non ha ancora votato e quindi si può procedere.
  * Verifica che l'elettore sia autorizzato a votare. Se il relativo valore booleano è vero significa che l'elettore è autorizzato, quindi va avanti.
  * Viene effettuata la votazione utilizzando l'indice del candidato che l'elettore ha scelto.
  * Registra che l'elettore ha effettuato il suo voto e quindi non dovrebbe essere in grado di votare di nuovo.
  * Incrementa di 1 il numero di voti per il candidato che è stato apena votato dall'elettore.
  * Incrementa il numero totale di voti effettuati.
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996722-ff6af353-4513-41bc-931d-d242f583aa01.png" width="550" height="160">
</p>
																		 
* Funzione per ottenere il numero di voti totali effettuati durante la votazione
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996718-6eb4ce85-ac89-4c69-adfe-2eef981ca390.png" width="500" height="80">
</p>
																		
* Funzione per ottenere le informazioni relative ai candidati
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996711-00fa2e6f-3afd-46f8-a2ac-fc972462a42f.png" width="600" height="70">
</p>
										

