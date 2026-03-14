import 'dart:ui';

Color getPokemonTypeColor(String? type) {
  switch (type?.toLowerCase()) {
    case 'fire': return const Color.fromARGB(255, 248, 36, 36);
    case 'grass': return const Color.fromARGB(255, 67, 213, 179);
    case 'water': return const Color.fromARGB(255, 97, 176, 250);
    case 'electric': return const Color.fromARGB(255, 251, 199, 57);
    case 'psychic': return const Color.fromARGB(255, 246, 72, 124);
    case 'poison': return const Color.fromARGB(255, 151, 69, 183);
    case 'ground': return const Color.fromARGB(255, 200, 168, 62);
    case 'rock': return const Color.fromARGB(255, 187, 161, 46);
    case 'ice': return const Color(0xff98D8D8);
    case 'dragon': return const Color(0xff7038F8);
    case 'ghost': return const Color(0xff705898);
    case 'bug': return const Color(0xffA8B820);
    case 'normal': return const Color(0xffA8A878); 
    case 'fighting': return const Color(0xffC03028);
    case 'flying': return const Color(0xffA890F0);
    case 'steel': return const Color(0xffB8B8D0);
    case 'dark': return const Color(0xff705848);  
    case 'fairy': return const Color(0xffEE99AC);  
    case 'stellar': return const Color(0xff40B5CF); 
    
    default: return const Color(0xffBCBBBB);
  }
}