import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/getTableSlotModel.dart';
import '../../models/reason.dart';
import '../../models/securityToolModel.dart';
import '../../models/skumodel.dart';
import '../../provider/tableSlotProvider.dart';
import '../../screens/toastmessage.dart';
import '../activityList/activitylistScreen.dart';
import '../lodingpage.dart';

class TableSlotForm extends StatefulWidget {
  static const routeName = "/slotForm";
  final String userName;
  final String workingId;
  final String storeId;
  final String companyId;
  final String tableTypeId;
  final String tableNameId;
  final String tableType;
  final String tableName;
  final String clientVisitType;

  TableSlotForm(
      {required this.userName,
      required this.workingId,
      required this.storeId,
      required this.companyId,
      required this.tableTypeId,
      required this.tableNameId,
      required this.tableType,
      required this.tableName,
      required this.clientVisitType});

  @override
  State<TableSlotForm> createState() => _TableSlotFormState();
}

class _TableSlotFormState extends State<TableSlotForm> {
  bool _isInit = true;
  bool _isLoading = false;

  List<GetTableSlotModel>? widgetsltData;
  List<SecurityToolModel>? widgetsecurityData;
  List<ReasonModel>? widgetreasonData;
  List<SkuModel>? widgetskuData;

  List<GlobalKey<FormState>> _formKeys = [GlobalKey<FormState>()];
  int _currentStep = 0;
  var slotUtilizeId = 0;
  var slotStatus = "";
  var notWorkingCheck = "";
  var selectedSecurityId = 0;
  var selectedReason = 0;
  var skuid = 0;
  double enteredPrice = 0.0;

  _stepTapped(int step) {
    if (this.mounted) {
      setState(() => _currentStep = step);
    }
  }

  void _submitAllSlotData() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      await Provider.of<TableSlotProvider>(context, listen: false)
          .updateAllSlot()
          .then((value) {
        if (value) {
          if (this.mounted) {
            setState(() {
              _isLoading = false;
            });
          }

          Navigator.of(context)
              .pushReplacementNamed(ActivityListScreen.routeName, arguments: {
            "userName": widget.userName,
            "workingId": widget.workingId,
            "storeId": widget.storeId,
            "companyId": widget.companyId,
            "clientVisitType": widget.clientVisitType
          });
          showingToastMessage.customToast("Slot upload successfully", context);
          return;
        } else {
          if (this.mounted) {
            setState(() {
              _isLoading = false;
            });
          }
          showingToastMessage.ErrorToast(
              "Some thing went wrong please try later", context);
        }
      });
    } catch (error) {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
        showingToastMessage.ErrorToast(error.toString(), context);
      }
    }
  }

  // This function will be called when the continue button is tapped
  _stepContinue() async {
    if (!_formKeys[_currentStep].currentState!.validate()) {
      return;
    }
    _formKeys[_currentStep].currentState!.save();
    if (_currentStep == widgetsltData!.length - 1) {
      submitSingleSlot(_currentStep + 1);
      _submitAllSlotData();
      return;
    }

    if (_currentStep < widgetsltData!.length - 1) {
      if (this.mounted) {
        setState(() {
          _currentStep += 1;
        });
      }

      submitSingleSlot(_currentStep);
    }
  }

  // This function will be called when the cancel button is tapped
  _stepCancel() {
    _currentStep > 0
        ? this.mounted
            ? setState(() => _currentStep -= 1)
            : null
        : null;
  }

  var routeArgs;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      try {
        if (this.mounted) {
          setState(() {
            _isLoading = true;
          });
        }
        await Provider.of<TableSlotProvider>(context, listen: false)
            .fetchTableSlot(
                routeArgs["userName"].toString(),
                routeArgs["workingId"].toString(),
                routeArgs["storeId"].toString(),
                routeArgs["companyId"].toString(),
                routeArgs["tableTypeId"].toString(),
                routeArgs["tableNameId"].toString(),
                routeArgs["clientVisitType"].toString())
            .then((_) async {
          await Provider.of<TableSlotProvider>(context, listen: false)
              .fetchMasterList(
                  routeArgs["userName"].toString(),
                  routeArgs["workingId"].toString(),
                  routeArgs["tableTypeId"].toString(),
                  routeArgs["clientVisitType"].toString())
              .then((value) async {
            await Provider.of<TableSlotProvider>(context, listen: false)
                .fetchSkus(
                    routeArgs["userName"].toString(),
                    routeArgs["workingId"].toString(),
                    routeArgs["storeId"].toString(),
                    routeArgs["companyId"].toString(),
                    routeArgs["tableTypeId"].toString(),
                    routeArgs["clientVisitType"].toString())
                .then((_) {
              if (this.mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            });
          });
        });

        widgetsltData = Provider.of<TableSlotProvider>(context, listen: false)
            .getTableSlots;

        for (var i = 0; i < widgetsltData!.length; i++) {
          _formKeys.insert(0, GlobalKey<FormState>());
        }

        widgetsecurityData =
            Provider.of<TableSlotProvider>(context, listen: false)
                .getSecurityToolItem
                .reversed
                .toList();
        widgetreasonData =
            Provider.of<TableSlotProvider>(context, listen: false)
                .getReasonItem
                .reversed
                .toList();
        widgetskuData = Provider.of<TableSlotProvider>(context, listen: false)
            .getSKUItem
            .reversed
            .toList();
      } catch (error) {
        // setState(() {
        //   _isLoading = false;
        // });
        if (this.mounted) {
          showingToastMessage.ErrorToast(error.toString(), context);
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  final List<String> lsttt2 = ["Utilize", "Empty"];
  final List<String> lsttt5 = ["Working", "NotWorking"];

  InputDecoration formDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.zero,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget securityDropDownBtn1(
      String hintText,
      List<SecurityToolModel> securityItem,
      String errorMessage,
      SecurityToolModel securityInitial) {
    return DropdownButtonFormField2<SecurityToolModel>(
        decoration: formDecoration(),
        value: securityInitial,
        isExpanded: true,
        hint: Text(hintText),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
        buttonHeight: 40,
        buttonPadding: const EdgeInsets.only(left: 0, right: 5),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        items: widgetsecurityData!
            .map((item) => DropdownMenuItem<SecurityToolModel>(
                  // value: item.securityToolId.toString(),
                  value: item,
                  child: Text(
                    item.name.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        validator: (value) {
          if (value == null || value.securityToolId == 0) {
            return errorMessage;
          }
          return null;
        },
        onChanged: (value) {
          if (this.mounted) {
            setState(() {
              selectedSecurityId = value!.securityToolId as int;
            });
          }
        },
        onSaved: (value) {
          selectedSecurityId = value!.securityToolId as int;
        });
  }

  Widget utilizeDropDownBtn(String hintText, String errorMessage,
      int slotUtilzngId, int slotNo, String myInitial) {
    return DropdownButtonFormField2(
        decoration: formDecoration(),
        value: myInitial,
        isExpanded: true,
        hint: Text(hintText),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
        buttonHeight: 40,
        buttonPadding: const EdgeInsets.only(left: 0, right: 5),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        items: lsttt2
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        validator: (value) {
          if (value == null) {
            return errorMessage;
          }
          return null;
        },
        onChanged: (value) {
          slotUtilizeId = slotUtilzngId;
          if (value == "Utilize") {
            if (this.mounted) {
              setState(() {
                slotStatus = "1";
                widgetsltData![slotNo - 1].status = 1;
              });
            }
          }
          if (value == "Empty") {
            if (this.mounted) {
              setState(() {
                slotStatus = "0";
                widgetsltData![slotNo - 1].status = 0;
              });
            }
          }
        },
        onSaved: (value) {
          slotUtilizeId = slotUtilzngId;
          if (value == "Utilize") {
            slotStatus = "1";
            widgetsltData![slotNo - 1].status = 1;
          }
          if (value == "Empty") {
            slotStatus = "0";
            widgetsltData![slotNo - 1].status = 0;
          }
        });
  }

  Widget reasonDropDownBtn1(
      String hintText, String errorMessage, ReasonModel? initialValue) {
    return DropdownButtonFormField2<ReasonModel>(
        decoration: formDecoration(),
        value: initialValue,
        isExpanded: true,
        hint: Text(hintText),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        // value: "",
        iconSize: 30,
        buttonHeight: 40,
        buttonPadding: const EdgeInsets.only(left: 0, right: 5),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        items: widgetreasonData!
            .map(
              (item) => DropdownMenuItem<ReasonModel>(
                value: item,
                child: Text(
                  item.reasonName.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            )
            .toList(),
        validator: (value) {
          if (value == null || value.reason == 0) {
            return errorMessage;
          }
          return null;
        },
        onChanged: (value) {
          if (this.mounted) {
            setState(() {
              selectedReason = value!.reason as int;
            });
          }
        },
        onSaved: (value) {
          selectedReason = value!.reason as int;
        });
  }

  Widget workingDropDownBtn(
      String hintText, String errorMessage, int slotNo, String myInitial) {
    return DropdownButtonFormField2(
        decoration: formDecoration(),
        value: myInitial,
        isExpanded: true,
        hint: Text(hintText),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
        buttonHeight: 40,
        buttonPadding: const EdgeInsets.only(left: 0, right: 5),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        items: lsttt5
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        validator: (value) {
          if (value == null) {
            return errorMessage;
          }

          return null;
        },
        onChanged: (value) {
          if (value == "Working") {
            if (this.mounted) {
              setState(() {
                widgetsltData![slotNo - 1].notWorkingCheck = 0;
              });
            }
          } else if (value == "NotWorking") {
            if (this.mounted) {
              setState(() {
                widgetsltData![slotNo - 1].notWorkingCheck = 1;
              });
            }
          }
          if (this.mounted) {
            setState(() {
              notWorkingCheck = value.toString();
            });
          }
        },
        onSaved: (value) {
          notWorkingCheck = value.toString();
        });
  }

  Widget productDropDownBtn1(
      String hintText, String errorMessage, SkuModel myInitial) {
    return DropdownButtonFormField2<SkuModel>(
        decoration: formDecoration(),
        value: myInitial,
        isExpanded: true,
        hint: Text(hintText),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
        buttonHeight: 40,
        buttonPadding: const EdgeInsets.only(left: 0, right: 5),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        items: widgetskuData!
            .map((item) => DropdownMenuItem<SkuModel>(
                  value: item,
                  child: Text(
                    item.skuName.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        validator: (value) {
          if (value == null) {
            return errorMessage;
          }
          return null;
        },
        onChanged: (value) {
          if (this.mounted) {
            setState(() {
              skuid = value!.skuId as int;
            });
          }
        },
        onSaved: (value) {
          skuid = value!.skuId as int;
        });
  }

  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Widget searchProdItem1(SkuModel myInitial) {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField2(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          isExpanded: true,
          hint: Text(
            'Select Item',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),

          items: widgetskuData!
              .map((item) => DropdownMenuItem<SkuModel>(
                    value: item,
                    child: Text(
                      item.skuName.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
              .toList(),
          value: myInitial,
          validator: (value) {
            if (value == null || value.skuId == 0) {
              return "Please select item";
            }
            return null;
          },
          onChanged: (value) {
            if (this.mounted) {
              setState(() {
                // selectedValue = value;
              });
            }
          },
          onSaved: (newValue) {
            skuid = newValue!.skuId as int;
          },
          buttonHeight: 40,
          buttonWidth: 200,
          itemHeight: 40,
          dropdownMaxHeight: 400,
          searchController: textEditingController,
          searchInnerWidget: Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'Search for an item...',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          searchMatchFn: (item, searchValue) {
            return (item.value.skuName.toLowerCase().contains(searchValue));
          },

          //This to clear the search value when you close the menu
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              textEditingController.clear();
            }
          },
        ),
      ),
    );
  }

  Widget priceForm(double initialPrice) {
    return TextFormField(
      initialValue: initialPrice.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 0, left: 10),
        hintText: "Price",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter price";
        }
        return null;
      },
      onSaved: ((newValue) {
        enteredPrice = double.parse(newValue!);
      }),
    );
  }

  void submitSingleSlot(int slotno) {
    Provider.of<TableSlotProvider>(context, listen: false).updateSlotsArray(
        slotno,
        widget.workingId,
        widget.storeId,
        widget.companyId,
        widget.tableTypeId,
        widget.tableNameId,
        widget.tableType,
        widget.tableName,
        slotUtilizeId,
        slotStatus,
        notWorkingCheck,
        selectedReason,
        selectedSecurityId,
        skuid,
        enteredPrice);
  }

  List<Step> stepList() {
    return widgetsltData!
        .map(
          (e) => Step(
            isActive: _currentStep == e.slotNo - 1,
            title: Text(
              "Slot no: ${e.slotNo}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Form(
              key: _formKeys[e.slotNo - 1],
              child: Column(
                children: [
                  utilizeDropDownBtn(
                      "Status",
                      "Please select status",
                      e.slotUtilizingId,
                      e.slotNo,
                      e.status == 1 ? "Utilize" : "Empty"),
                  const SizedBox(
                    height: 10,
                  ),
                  if (e.status == 1)
                    Column(
                      children: [
                        securityDropDownBtn1(
                            "Security Tool",
                            widgetsecurityData!,
                            "Please select security tool",
                            Provider.of<TableSlotProvider>(context,
                                    listen: false)
                                .findSecurityElement(e.securityToolId)),
                        const SizedBox(
                          height: 10,
                        ),
                        workingDropDownBtn(
                            "Slot Status",
                            "Please select slot status",
                            e.slotNo,
                            e.notWorkingCheck == 0 ? "Working" : "NotWorking"),
                        const SizedBox(
                          height: 10,
                        ),
                        e.notWorkingCheck == 1
                            ? reasonDropDownBtn1(
                                "Reason",
                                "Please select slot reason",
                                Provider.of<TableSlotProvider>(context,
                                        listen: false)
                                    .findReason(e.reason))
                            : Container(),
                        e.notWorkingCheck == 1
                            ? const SizedBox(
                                height: 10,
                              )
                            : Container(),
                        searchProdItem1(Provider.of<TableSlotProvider>(context,
                                listen: false)
                            .findSKUElement(e.skuId)),
                        const SizedBox(
                          height: 10,
                        ),
                        priceForm(e.price)
                      ],
                    )
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container(
            padding: EdgeInsets.only(top: 50),
            height: 120,
            child: MyLoadingSpinner())
        : widgetsltData!.isEmpty
            ? Container(
                padding: EdgeInsets.only(top: 100),
                child: Text("No slot is available"),
              )
            : Stepper(
                controlsBuilder: (context, _) {
                  return Row(
                    children: [
                      ElevatedButton(
                          onPressed: _stepContinue,
                          child: _currentStep == widgetsltData!.length - 1
                              ? Text("Submit")
                              : Text("Next")),
                      TextButton(onPressed: _stepCancel, child: Text("Cancel")),
                    ],
                  );
                },
                physics: const NeverScrollableScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) => _stepTapped(step),
                onStepContinue: _stepContinue,
                onStepCancel: _stepCancel,
                steps: stepList());
  }
}
