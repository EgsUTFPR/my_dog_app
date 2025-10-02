import 'package:go_router/go_router.dart';
import 'package:my_dog_app/controller/pet_controller.dart';
import 'package:my_dog_app/models/dono_model.dart';
import 'package:my_dog_app/models/passeador_model.dart';
import 'package:my_dog_app/views/tela_cadastro.dart';
import 'package:my_dog_app/views/tela_inicial.dart';
import 'package:my_dog_app/views/tela_inicial_dono.dart';
import 'package:my_dog_app/views/tela_inicial_passeador.dart';
import 'package:my_dog_app/views/tela_login.dart';
import 'package:my_dog_app/views/tela_cadastro_pet.dart';

final routes = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TelaInicial()),
    GoRoute(path: '/login', builder: (context, state) => const telaLogin()),

    GoRoute(
      path: '/cadastro',
      builder: (context, state) => const telaCadastro(),
    ),

    GoRoute(
      path: '/tela-inicial-dono',
      builder: (context, state) {
        final dono = state.extra as Dono; // recebe o objeto passado
        return TelaInicialDono(dono: dono);
      },
    ),
    GoRoute(
      path: '/tela-inicial-passeador',
      builder: (context, state) {
        final passeador = state.extra as Passeador; // recebe o objeto passado
        return TelaInicialPasseador(passeador: passeador);
      },
    ),
    GoRoute(
      path: '/tela-cadastro-pet',
      builder: (context, state) {
        final petcontroller = state.extra as PetController;
        return TelaCadastroPet(
          donoEmail: "Teste@gmail.com",
          petController: petcontroller,
        );
      },
    ),
  ],
);
