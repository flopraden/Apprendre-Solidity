/* Ce contrat est une version raffinée de MetacoinNAIF
 Il s'inspire notamment du contrat Coin consultable ici
http://solidity.readthedocs.io/en/latest/introduction-to-smart-contracts.html
*/


contract metaCoinv2 {
    // The keyword "public" makes those variables
    // readable from outside.
    address public minter;
    mapping (address => uint) public balances;

    // Events allow light clients to react on
    // changes efficiently.
    event Sent(address from, address to, uint amount);

    // This is the constructor whose code is
    // run only when the contract is created.
    function Coin() {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) {
        if (msg.sender != minter) return;
        balances[receiver] += amount;
    }

    function send(address receiver, uint amount) {
        if (balances[msg.sender] < amount) return;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        Sent(msg.sender, receiver, amount);
    }
}

contract metaCoin {	
    /* 'contract' est similaire à 'class' dans d'autres langages (class variables,
inheritance, etc.) */
    // On déclare ici les variables d'état hors des fonctions

	mapping (address => uint) balances;
	
    /* mapping est un dictionnaire associant les adresses "address"
    à des soldes "uint". Par défaut les "mapping" sont publics, i.e quiconque
    peut faire une requête de lecture. Le complément "public" es généralement 
    ajouté pour lever l'ambuguïté "mapping (address => uint) public balances;"
    On peut bien sûr préciser "private" à la place pour qu'il soit impossible 
    de faire des requêtes sur le mapping sauf pour le contrat lui-même
    Notez que ces données restent néanmoins "visibles" sur la blockchain
    Avec private on aurait : mapping (address => uint) private balances; */
	
	function metaCoin() {
		balances[msg.sender] = 10000;
	}
	
	/* la fonction metaCoin est la fonction de création monétaire. Elle peut 
	être appelée par n'importe qui, l'appel se fait dans une transaction à 
	partir d'une adresse ethereum, cette transaction est représentée en solidity
	par "msg", "msg.sender" correspond à l'addresse qui émet cette transaction. 
	La fonction metaCoin modifie le mapping "balances" en associant le nombre 
	100000 à l'adresse de l'émetteur de la transaction que le contrat lit sur 
	"msg.sender".
	Cette fonction est assez naïve car tout le monde peut mettre le solde de son
	adresse à 10000. Il est tout à fait possible de restreidre l'accès à cette
	fonction par un "if" ou plus généralement par un "modifier", ces méthodes
	seront mobilisées dans d'autres contrats */
	
	function sendCoin(address receiver, uint amount) returns(bool sufficient) {
	    /* sendCoin est la fonction de transfert de monnaie. Cette fonction 
	    peut être appelée par n'importe qui. Elle prend en input l'adresse à 
	    créditer sous "receiver" qui doit être du type "address" et un montant
	    sous "amount" qui doit être du type "uint". Selon les cas elle retourne
	    "sufficient"=vrai si les fonds du solliciteur de la fonction sont 
	    suffisants et "sufficient"=faux dans le cas contraire. Dans le cas vrai
	    la fonction exécute le transfert c'est à dire crédite et débite les
	    adresses correspondantes dans le mapping "balances": */
	    
	    if (balances[msg.sender] < amount) return false;
	    /* la condition "if" vérifie qu'un "amount" suffisant est associé dans
	    le mapping "balances" à l'adresse qui sollicite la fonction "sendCoin".
	    Notez que le test est strict, si l'adresse "msg.sender" est associé à un
	    solde égale à "amount" le retour de la fonction sera faux. Lorsque la 
	    condition balances[msg.sender] < amount n'est pas vérifié le reste du 
	    code s'exécute: */
	    
		balances[msg.sender] -= amount;
		// Le mapping "balances" est modifié. L'envoyeur est débité de "amount" 
		balances[receiver] += amount;
		// Le mapping "balances" est modifié. Le récepteur est crédité
		return true;
		/* La fonction sendCoin retourne "vrai" pour signaler que les fonds 
		était suffisants et que le transfert a été effectué*/
	}
}
/* Ce contrat une fois déployé sera stocké dans la blockchain, il se termine 
sans possibilité de l'en retirer. Une bonne pratique est d'ajouter cette option
avec la fonction "selfdestruct(address)". Chaque opération consomme du gaz sous
la forme d'Ether, il est donc nécessaire d'optimiser le code pour alléger les
frais d'utilisation du contrat. La fonction "selfdestruct" est une exception et
consomme un gaz négatif. En effet, "selfdestruct" supprime le contrat et libère 
de l'espace sur la blockchain ce qui est encouragé par le protocole ethereum.
On peut préciser une adresse à "selfdestruct", si le contrat contient des ethers
ils seront transférés à l'adresse indiquée.
Le contrat MetaCoin v2 propose une optimisation de ce code.
*/