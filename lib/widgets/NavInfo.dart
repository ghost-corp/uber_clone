import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/models/location_model.dart' as location;

class NavInfo extends StatelessWidget {
  final location.Step currentStep;
  final location.Step nextStep;
  final location.Step futureStep;
  NavInfo({this.currentStep, this.futureStep, this.nextStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.green),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              currentStep.maneuver != null
                  ? getManeuverIcon(currentStep.maneuver)
                  : getManeuverIcon(nextStep.maneuver),
              Text(
                currentStep.distance,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              currentStep.maneuver != null
                  ? currentStep.maneuver
                  : nextStep.maneuver,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          )
        ],
      ),
    );
  }
}

Icon getManeuverIcon(String info) {
  Color color = Colors.white;
  double size = 30;
  switch (info) {
    case "keep-right":
      return Icon(Icons.arrow_forward, color: color, size: size);

    case "keep-left":
      return Icon(Icons.arrow_back, color: color, size: size);

    case "turn-right":
      return Icon(Icons.arrow_forward, color: color, size: size);

    case "turn-left":
      return Icon(Icons.arrow_back, color: color, size: size);

    case "ramp-left":
      return Icon(Icons.arrow_back, color: color, size: size);

    case "ramp-right":
      return Icon(Icons.arrow_forward, color: color, size: size);

    case "fork-left":
      return Icon(Icons.arrow_back, color: color, size: size);

    case "fork-right":
      return Icon(Icons.arrow_forward, color: color, size: size);

    default:
      return Icon(Icons.error_outline, color: color, size: size);
  }
}
