import 'package:flutter/rendering.dart';
import 'package:fvm_app/components/atoms/typography.dart';
import 'package:fvm_app/components/molecules/project_version_select.dart';
import 'package:fvm_app/components/molecules/version_install_button.dart';

import 'package:fvm_app/providers/flutter_releases.provider.dart';

import 'package:fvm_app/providers/installed_versions.provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fvm/fvm.dart';
import 'package:fvm_app/utils/open_link.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:truncate/truncate.dart';

class ProjectItem extends HookWidget {
  final FlutterProject project;
  const ProjectItem(this.project, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final installedVersions = useProvider(installedVersionsProvider);
    final version = useProvider(getVersionProvider(project.pinnedVersion));
    final description = project.pubspec.description.valueOr(() => '');

    final needInstall = version != null && project.pinnedVersion != null;

    return Container(
      height: 170,
      child: Center(
        child: Card(
          child: Column(
            children: [
              Container(
                child: ListTile(
                  leading: const Icon(MdiIcons.alphaPBox),
                  title: Subheading(project.name),
                  trailing: IconButton(
                    iconSize: 20,
                    icon: const Icon(MdiIcons.cog),
                    onPressed: () {},
                  ),
                ),
              ),
              const Divider(height: 0, thickness: 1),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          Paragraph(
                            description,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Divider(thickness: 1, height: 0),
              Row(
                children: [
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      openLink(project.projectDir.path);
                    },
                    child: Text(
                      truncate(project.projectDir.path, 25,
                          position: TruncatePosition.middle),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const Spacer(),
                  needInstall
                      ? VersionInstallButton(version, warningIcon: true)
                      : const SizedBox(height: 0, width: 0),
                  ProjectVersionSelect(
                    project: project,
                    versions: installedVersions,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
