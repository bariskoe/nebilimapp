import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nebilimapp/bloc/settings_bloc/bloc/settings_bloc.dart';
import 'package:nebilimapp/custom_widgets/standard_page_widget.dart';
import 'package:nebilimapp/dependency_injection.dart';
import 'package:nebilimapp/ui/ui_constants/ui_constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    getIt<SettingsBloc>().add(const SettingsEventGetAllSettings());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return StandardPageWidget(
          appBarTitle: 'Settings',
          child: SingleChildScrollView(
              child: Column(
            children: [
              /// Category selection container
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(UiConstantsPadding.large),
                      child: Text(
                        'Categories',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    _buildCategories(state),
                  ],
                ),
              )
            ],
          )),
        );
      },
    );
  }

  _buildCategories(SettingsState state) {
    _categorySymbolBuilder(SettingsStateLoaded state) {
      // List<Widget> list = [];
      // Map<
      // for(abc in state.settingsModel.categorySettingsModel)
    }

    if (state is SettingsStateLoaded) {
      return Text('${state.settingsModel.categorySettingsModel.props.asMap()}');
      // Wrap(
      //   children: [],
      // );
    } else {
      return Text('not Loaded state: $state');
    }
  }
}

class CategorySymbol extends StatelessWidget {
  const CategorySymbol({
    Key? key,
    required this.name,
    required this.icon,
    required this.selected,
  }) : super(key: key);
  final String name;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UiConstantsPadding.regular),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UiConstantsRadius.regular),
        border: Border.all(
            width: selected ? 4 : 1,
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(width: UiConstantsPadding.small),
          Icon(icon)
        ],
      ),
    );
  }
}
