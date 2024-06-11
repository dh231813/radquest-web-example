import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:RadQuest/player/player_bearded_dude.dart';
import 'package:RadQuest/player/player_sprite.dart';
import'package:RadQuest/npcs/base_npc.dart';

// Specific NPC class
class PatientNPC_v2 extends QuizNPC {
  @override
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Wie viel Strahlung werde ich abbekommen?',
      'answers': [
        'A. 1-10 mSv',
        'B. 10-50 mSv',
        'C. Weniger als 1 mSv',
        'D. 50-100 mSv'
      ],
      'correctAnswerIndex': 2,
      'explanation': 'Diese Menge an Strahlung ist sehr gering und liegt weit unter den Grenzwerten, die als gefährlich gelten. Daher besteht kein erhöhtes Krebsrisiko durch diese Untersuchung.'
    },
    {
      'question': 'Wie lange dauert die MRT-Untersuchung?',
      'answers': [
        'A. 10-20 Minuten',
        'B. 30-60 Minuten',
        'C. 1-2 Stunden',
        'D. Mehr als 2 Stunden'
      ],
      'correctAnswerIndex': 1,
      'explanation': 'Diese Zeit kann je nach zu untersuchendem Bereich und spezifischen Anforderungen variieren.'
    },
    {
      'question': 'Wie sollte ich mich während der MRT-Untersuchung verhalten?',
      'answers': [
        'A. Ruhig liegen bleiben',
        'B. Tief ein- und ausatmen',
        'C. Sich regelmäßig bewegen',
        'D. Mit dem Arzt sprechen'
      ],
      'correctAnswerIndex': 0,
      'explanation': 'Während einer MRT-Untersuchung ist es wichtig, so still wie möglich zu liegen, um klare Bilder zu erhalten.'
    },
    {
      'question': 'Kann ich während der MRT-Untersuchung essen?',
      'answers': [
        'A. Ja, es ist erlaubt',
        'B. Nein, es ist nicht erlaubt',
        'C. Nur kleine Snacks',
        'D. Nur Wasser trinken'
      ],
      'correctAnswerIndex': 1,
      'explanation': 'Vor einer MRT-Untersuchung sollten Sie normalerweise nichts essen, um die Bildqualität nicht zu beeinträchtigen.'
    },
    {
      'question': 'Was passiert, wenn ich Angst vor engen Räumen habe?',
      'answers': [
        'A. Die Untersuchung wird abgebrochen',
        'B. Es werden Beruhigungsmittel verabreicht',
        'C. Nichts, es geht weiter',
        'D. Sie werden hypnotisiert'
      ],
      'correctAnswerIndex': 1,
      'explanation': 'Wenn Sie unter Klaustrophobie leiden, kann Ihr Arzt Ihnen ein Beruhigungsmittel geben, um Ihnen zu helfen, sich zu entspannen.'
    },
    {
      'question': 'Kann ich während der MRT-Untersuchung Musik hören?',
      'answers': [
        'A. Ja, das ist möglich',
        'B. Nein, das ist nicht möglich',
        'C. Nur klassische Musik',
        'D. Nur über Kopfhörer'
      ],
      'correctAnswerIndex': 0,
      'explanation': 'Viele moderne MRT-Geräte ermöglichen es Ihnen, während der Untersuchung Musik zu hören, um Ihnen zu helfen, sich zu entspannen.'
    },
    {
      'question': 'Welche Kleidung sollte ich zur MRT-Untersuchung tragen?',
      'answers': [
        'A. Bequeme, metallfreie Kleidung',
        'B. Jeans und T-Shirt',
        'C. Sportkleidung',
        'D. Jegliche Kleidung'
      ],
      'correctAnswerIndex': 0,
      'explanation': 'Es ist wichtig, dass Sie keine metallischen Gegenstände tragen, da diese das MRT-Bild stören können.'
    },
    {
      'question': 'Kann ich Schmuck während der MRT-Untersuchung tragen?',
      'answers': [
        'A. Ja, das ist kein Problem',
        'B. Nur kleine Ringe',
        'C. Nein, Schmuck muss entfernt werden',
        'D. Nur Ohrringe'
      ],
      'correctAnswerIndex': 2,
      'explanation': 'Metallischer Schmuck kann das Magnetfeld des MRT stören und sollte daher vor der Untersuchung abgelegt werden.'
    },
  ];

  PatientNPC_v2(Vector2 position)
      : super(
    position: position,
    animation: SimpleDirectionAnimation(
      idleRight: DoctorCTSpriteSheet.idleRightSingleFrame,
      runRight: DoctorCTSpriteSheet.idleRightSingleFrame,
    ),
  );
}
