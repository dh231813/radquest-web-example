import 'package:RadQuest/decorations/chest.dart';
import 'package:RadQuest/decorations/coil_knee.dart';
import 'package:RadQuest/decorations/contrast_agent_barium.dart';
import 'package:RadQuest/decorations/contrast_agent_jod.dart';
import 'package:RadQuest/decorations/contrast_agent_primovist.dart';
import 'package:RadQuest/decorations/coil_head.dart';
import 'package:RadQuest/decorations/coil_hand.dart';
import 'package:RadQuest/decorations/coil_foot.dart';
import 'package:RadQuest/decorations/coil_knee.dart';
import 'package:RadQuest/interface/player_interface.dart';
import 'package:RadQuest/inventory_widget.dart';
import 'package:RadQuest/npcs/doctor_coil_npc.dart';
import 'package:RadQuest/npcs/doctor_ct_npc.dart';
import 'package:RadQuest/npcs/doctor_mrt_npc.dart';
import 'package:RadQuest/npcs/doctor_ultrasound_npc.dart';
import 'package:RadQuest/npcs/doctor_xray_npc.dart';
import 'package:RadQuest/npcs/patient_npc_02.dart';
import 'package:RadQuest/npcs/ordi_npc.dart';
import'package:RadQuest/npcs/doctor_contrastagent_npc.dart';


import 'package:RadQuest/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:RadQuest/player/player_serife.dart';
import 'package:RadQuest/player/player_sprite.dart';
import 'package:RadQuest/decorations/contrast_agent_gadolinium.dart';
import 'package:RadQuest/utilities/badge_display.dart';

double tileSize = 64.0;

class HospitalMap extends StatefulWidget {
  const HospitalMap({Key? key}) : super(key: key);
  @override
  State<HospitalMap> createState() => _HospitalMapState();
}


class _HospitalMapState extends State<HospitalMap>  {

  List<String> inventory = [];
  void addItemToInventory(String imagePath) {
    setState(() {
      inventory.add(imagePath);
    });
  }


  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    final tileSize = max(sizeScreen.height, sizeScreen.width)/15;

    return Scaffold(
      body: Stack(
        children:[
          BonfireWidget(
      map:
      WorldMapByTiled(WorldMapReader.fromAsset('tiled/Radquest_Level.json'),

        forceTileSize: Vector2(tileSize, tileSize),
        objectsBuilder: {

        // NPCs
          'ordi': (properties) => OrdiNPC(properties.position),
          'patient': (properties) => PatientNPC_v2(properties.position),

          'doctor_cbogen': (properties) => DoctorXRayNPC(properties.position),
          'doctor_ultrasound': (properties) => DoctorUltrasoundNPC(properties.position),
          'doctor_mrt_offen': (properties) => DoctorMRTNPC(properties.position),
          'doctor_ct': (properties) => DoctorCTNPC(properties.position),


          'doctor_contrast_agent': (properties) => createDoctorContrastAgentNPC(properties.position),
          'doctor_coil': (properties) => createDoctorCoilNPC(properties.position),

          'final_item': (properties) => Chest(properties.position),

          // Contrast Agents
          kGadoliniumCollectible: (p) => GadoliniumDecoration(p.position),
          kBariumCollectible: (p) => BariumDecoration(p.position),
          kJodCollectible: (p) => JodDecoration(p.position),
          kPrimovistCollectible: (p) => PrimovistDecoration(p.position),

          // Coils
          kHeadCoilCollectible: (p) => HeadCoilDecoration(p.position),
          kFootCoilCollectible: (p) => FootCoilDecoration(p.position),
          kHandCoilCollectible: (p) => HandCoilDecoration(p.position),
          kKneeCoilCollectible: (p) => KneeCoilDecoration(p.position),
        },

      ),


      showCollisionArea: false,
      interface: PlayerInterface(),
              player: PlayerSerife(
                Vector2(650, 154),
                //Vector2(tileSize * 20, tileSize * 3),
                spriteSheet: PlayerSpriteSheet.all,
                initDirection: Direction.down,
              ),


              playerControllers: [

        Joystick(directional: JoystickDirectional()),
        Keyboard(
        config: KeyboardConfig(
        enable: true, // Use to enable ou disable keyboard events (default is true)
        acceptedKeys: [ // You can pass specific Keys accepted. If null accept all keys
        LogicalKeyboardKey.space,

    ], // Type of the directional (arrows or wasd)
    ), // Here you enable receive keyboard interaction
    )
    ],
            cameraConfig: CameraConfig(
              moveOnlyMapArea: true,
            ),


    ),

    InventoryWidget(itemImages: inventory),
    ],
    ),
    );
  }

}



