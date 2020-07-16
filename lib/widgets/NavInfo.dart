import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/models/location_model.dart' as location;

class NavInfo extends StatefulWidget {
  final location.Step currentStep;
  final location.Step nextStep;
  final location.Step futureStep;
  final VoidCallback onMenuTap;
  NavInfo({this.currentStep, this.futureStep, this.nextStep, this.onMenuTap});
  @override
  State createState() => NavInfoState();
}

class NavInfoState extends State<NavInfo> {
  location.Step currentStep;
  location.Step nextStep;
  location.Step futureStep;
  VoidCallback onMenuTap;

  @override
  void initState() {
    onMenuTap = widget.onMenuTap;
    if (widget.currentStep != null) {
      print(widget.currentStep);
      currentStep = widget.currentStep;
    } else {
      currentStep = location.Step();
    }
    if (widget.nextStep != null) {
      print(widget.nextStep);
      nextStep = widget.nextStep;
    } else {
      nextStep = location.Step();
    }
    if (widget.futureStep != null) {
      print(widget.futureStep);
      futureStep = widget.futureStep;
    } else {
      futureStep = location.Step();
    }
    super.initState();
  }

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
                  : nextStep.maneuver != null
                      ? getManeuverIcon(nextStep.maneuver)
                      : futureStep.maneuver != null
                          ? getManeuverIcon(futureStep.maneuver)
                          : Icon(Icons.error_outline, color: Colors.white),
              Text(
                currentStep.distance != null ? currentStep.distance : "...",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              )
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              currentStep.maneuver != null
                  ? currentStep.maneuver[0].toUpperCase() +
                      currentStep.maneuver.substring(1)
                  : nextStep.maneuver != null
                      ? nextStep.maneuver[0].toUpperCase() +
                          nextStep.maneuver.substring(1)
                      : futureStep.maneuver != null
                          ? futureStep.maneuver[0].toUpperCase() +
                              futureStep.maneuver.substring(1)
                          : "...",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
              onTap: onMenuTap,
              child: Icon(
                Icons.menu,
                size: 40,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

Icon getManeuverIcon(String info) {
  Color color = Colors.white;
  double size = 35;
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
