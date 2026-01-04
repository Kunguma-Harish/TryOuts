//
//  ViewController.swift
//  showXwhiteboard
//
//  Created by Kunguma Harish P on 03/11/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    /*
     # CustomSwiftProtobuf.rb
     # Public API: editSwiftProtobuf, updateWhiteBoardProtoFiles
     # All helper methods are private

     def editSwiftProtobuf(installer, namemap_computed_checksum, namemap_desired_checksum, enum_computed_checksum, enum_desired_checksum)
         # MARK: Edit NameMap.swift
         if !namemap_computed_checksum.eql? namemap_desired_checksum
             print "Modifying NameMap.swift\n"
             addCustomVarCount = '
     public extension _NameMap {
         /// Customised for use with Zoho Show iOS
         internal var count: Int {
             return numberToNameMap.count
         }
     }
             '

             name_map_file_path = Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/NameMap.swift'
             FileUtils.chmod('u+w', name_map_file_path)
             File.write('Pods/SwiftProtobuf/Sources/SwiftProtobuf/NameMap.swift', addCustomVarCount, mode: 'a+')
         end

         # MARK: Edit Enum.swift
         if !enum_computed_checksum.eql? enum_desired_checksum
             print "Modifying Enum.swift\n"
             enum_file_path = Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/Enum.swift'
             FileUtils.chmod('u+w', enum_file_path)
             system "sed -i '' 's/internal init?(name: String) {/public init?(name: String) {/g' \"#{enum_file_path}\""
         end

         #MARK: Add ShowExtensions.swift

         FileUtils.chmod('u+r', Dir.pwd + '/SwiftProtobufExtension/native/Extensions/ShowExtensions.swift')
         if File.exist?(Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/ShowExtensions.swift')
                 FileUtils.chmod('u+w', Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/ShowExtensions.swift')
                 FileUtils.remove_dir Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/ShowExtensions.swift'
         end

         # Copy ShowExtensions.swift to 'Pods/SwiftProtobuf/Sources/SwiftProtobuf' directory
         FileUtils.copy (Dir.pwd + '/SwiftProtobufExtension/native/Extensions/ShowExtensions.swift'), (Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf')

         # Add file reference to ShowExtensions.swift in SwiftProtobuf group
         file_ref = installer.pods_project.add_file_reference(
             Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/ShowExtensions.swift',
             installer.pods_project.pod_group('SwiftProtobuf'),
         )

         FileUtils.chmod('u+r', Dir.pwd + '/SwiftProtobufExtension/native/Extensions/DeltaDecoder.swift')
         if File.exist?(Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/DeltaDecoder.swift')
                 FileUtils.chmod('u+w', Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/DeltaDecoder.swift')
                 FileUtils.remove_dir Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/DeltaDecoder.swift'
         end

         # Copy DeltaDecoder.swift to 'Pods/SwiftProtobuf/Sources/SwiftProtobuf' directory
         FileUtils.copy (Dir.pwd + '/SwiftProtobufExtension/native/Extensions/DeltaDecoder.swift'), (Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf')

         # Add file reference to ShowExtensions.swift in SwiftProtobuf group
         file_ref1 = installer.pods_project.add_file_reference(
             Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/DeltaDecoder.swift',
             installer.pods_project.pod_group('SwiftProtobuf'),
         )

         # Set target membership for ShowExtensions.swift
         swift_protobuf_targets = installer.pods_project.targets.select { |t| t.display_name =~ /^SwiftProtobuf/ } # Fetch all targets whose name begins with 'SwiftProtobuf'
         swift_protobuf_resource_targets = installer.pods_project.targets.select { |t| t.display_name =~ /-SwiftProtobuf$/ } # Fetch all targets whose name ends with '-SwiftProtobuf'. These are bundle targets
         swift_protobuf_targets -= swift_protobuf_resource_targets # Exclude bundle targets

         for target in swift_protobuf_targets
             target.add_file_references([file_ref, file_ref1])
         end
     end

     # Main function to rename duplicate proto files and update struct references
     # @param installer [Installer] CocoaPods installer instance
     def updateWhiteBoardProtoFiles(installer)
         puts "\n ************* Update WhiteBoard Proto Files ************* \n"
         
         # Configuration: files to rename with their struct mappings
         file_configs = [
             {
                 rel_path: 'proto/share/whiteboard/custom.pb.swift',
                 new_name: 'whiteboard_custom.pb.swift',
                 old_struct: 'Custom',
                 new_struct: 'WhiteboardCustom'
             },
             {
                 rel_path: 'proto/whiteboard/document.pb.swift',
                 new_name: 'whiteboard_document.pb.swift',
                 old_struct: 'Document',
                 new_struct: 'WhiteboardDocument'
             },
             {
                 rel_path: 'proto/whiteboard/build/documentdata.pb.swift',
                 new_name: 'whiteboard_documentdata.pb.swift',
                 old_struct: 'DocumentData',
                 new_struct: 'WhiteboardDocumentData'
             }
         ]
         
         # Build modification configurations with generated replacements
         file_modifications = file_configs.map do |config|
             dir = File.dirname(config[:rel_path])
             old_rel = File.join('Proto', config[:rel_path])
             new_rel = File.join('Proto', dir, config[:new_name])
             
             {
                 old_path: proto_file_path(config[:rel_path]),
                 new_path: proto_file_path(File.join(dir, config[:new_name])),
                 old_rel: old_rel,
                 new_rel: new_rel,
                 struct_renames: generate_struct_replacements(config[:old_struct], config[:new_struct])
             }
         end
         
         # Step 1: Rename files and modify struct names
         file_modifications.each do |mod|
             rename_and_modify_file(mod[:old_path], mod[:new_path], mod[:struct_renames])
         end
         
         # Step 2: Update references in dependent files
         reference_updates = [
             {
                 file_path: proto_file_path('proto/whiteboard/build/projectdata.pb.swift'),
                 struct_renames: { '[DocumentData]' => '[WhiteboardDocumentData]' }
             },
             {
                 file_path: proto_file_path('proto/whiteboard/build/whiteboard_documentdata.pb.swift'),
                 struct_renames: generate_struct_replacements('Document', 'WhiteboardDocument')
                     .select { |k, _| k.match?(/\?\?|:.*\?|:.*\s/) }
             }
         ]
         
         reference_updates.each do |update|
             update_file_references(update[:file_path], update[:struct_renames])
         end

         # Step 3: Update Xcode project references
         update_xcode_references(installer, file_modifications)
         
         puts "\n✓ All duplicate proto files have been renamed and struct names updated!"
     end

     # ============================================================================
     # Private Helper Methods
     # ============================================================================
     private

     # Generates standard Swift struct replacement patterns for renaming a type
     # @param old_name [String] Original struct name (e.g., 'Custom')
     # @param new_name [String] New struct name (e.g., 'WhiteboardCustom')
     # @return [Hash] Mapping of old patterns to new patterns
     def generate_struct_replacements(old_name, new_name)
         {
             "public struct #{old_name}" => "public struct #{new_name}",
             "struct #{old_name}:" => "struct #{new_name}:",
             "#{old_name}.self" => "#{new_name}.self",
             "#{old_name}." => "#{new_name}.",
             "#{old_name}:" => "#{new_name}:",
             "return #{old_name}(" => "return #{new_name}(",
             "var custom: #{old_name}" => "var custom: #{new_name}",
             ": #{old_name}?" => ": #{new_name}?",
             ": #{old_name} " => ": #{new_name} ",
             "(#{old_name}, #{old_name})" => "(#{new_name}, #{new_name})",
             "lhs: #{old_name}" => "lhs: #{new_name}",
             "rhs: #{old_name}" => "rhs: #{new_name}",
             "<#{old_name}>" => "<#{new_name}>",
             "[#{old_name}]" => "[#{new_name}]",
             " #{old_name}>" => " #{new_name}>",
             " #{old_name}," => " #{new_name},",
             "?? #{old_name}()" => "?? #{new_name}()"
         }
     end

     # Builds full file path from relative proto path
     # @param rel_path [String] Relative path under Proto directory
     # @return [String] Absolute file path
     def proto_file_path(rel_path)
         File.join(Dir.pwd, 'Pods', 'Proto', rel_path)
     end

     # Updates Xcode project file references
     # @param installer [Installer] CocoaPods installer instance
     # @param modifications [Array<Hash>] Array of file modification configs
     def update_xcode_references(installer, modifications)
         modifications.each do |mod|
             proto_group = installer.pods_project.pod_group('Proto')
             # Ensure a file reference exists for the NEW path
             new_ref = installer.pods_project.files.find { |f| f.path == mod[:new_rel] || f.path == mod[:new_rel].sub(/^Proto\//, '') }
             unless new_ref
                 absolute_new_path = File.join(Dir.pwd, 'Pods', mod[:new_rel])
                 puts "Kungu: absolute_new_path: #{absolute_new_path}"
                 if File.exist?(absolute_new_path)
                     new_ref = installer.pods_project.add_file_reference(
                         absolute_new_path,
                         proto_group,
                     )
                     puts "Added project reference: #{File.basename(mod[:new_rel])}"
                 else
                     puts "  ⚠ New file missing on disk: #{absolute_new_path}"
                     next
                 end
             end

             # Ensure new ref is in non-bundle 'Proto' targets' Compile Sources
             proto_targets = installer.pods_project.targets.select { |t| t.display_name =~ /^Proto/ }
             proto_resource_targets = installer.pods_project.targets.select { |t| t.display_name =~ /-Proto$/ }
             proto_targets -= proto_resource_targets
             for target in proto_targets
                 unless target.source_build_phase.files_references.include?(new_ref)
                     target.add_file_references([new_ref])
                 end
             end

             # Find and remove the OLD reference from targets and project
             old_ref = installer.pods_project.files.find { |f| f.path == mod[:old_rel] || f.path == mod[:old_rel].sub(/^Proto\//, '') }
             if old_ref
                 for target in proto_targets
                     if target.source_build_phase.files_references.include?(old_ref)
                         target.source_build_phase.remove_file_reference(old_ref)
                     end
                 end
                 old_ref.remove_from_project
                 puts "Removed old project reference: #{File.basename(mod[:old_rel])}"
             else
                 puts "  ℹ No old project reference found for #{mod[:old_rel]}"
             end

             # Delete the OLD file on disk if present
             begin
                 if File.exist?(mod[:old_path])
                     begin
                         FileUtils.chmod('u+w', mod[:old_path])
                     rescue Errno::ENOENT
                         # File vanished between exist? and chmod; ignore
                     end
                     FileUtils.rm_f(mod[:old_path])
                     puts "Deleted old file on disk: #{File.basename(mod[:old_path])}"
                 end
             rescue => e
                 puts "  ⚠ Failed to delete old file #{mod[:old_path]}: #{e.message}"
             end
         end
         installer.pods_project.save
     end

     # Renames a file and applies struct name replacements
     # @param old_path [String] Original file path
     # @param new_path [String] New file path
     # @param replacements [Hash] Struct name replacement mapping
     def rename_and_modify_file(old_path, new_path, replacements)
         return unless File.exist?(old_path)
         
         begin
             unless File.readable?(old_path)
                 puts "  ⚠ Skipping #{File.basename(old_path)}: File is not readable"
                 return
             end
             
             # Read and modify content
             content = File.read(old_path)
             replacements.each { |old_text, new_text| content.gsub!(old_text, new_text) }
             
             # Ensure destination directory exists
             dest_dir = File.dirname(new_path)
             Dir.mkdir(dest_dir) unless Dir.exist?(dest_dir)

             # Write modified content to new file, keep original to satisfy CocoaPods locking
             FileUtils.chmod('u+w', new_path) if File.exist?(new_path)
             File.write(new_path, content)
         rescue => e
             puts "  ⚠ Error processing #{File.basename(old_path)}: #{e.message}"
         end
     end

     # Updates struct references in an existing file without renaming
     # @param file_path [String] Path to file to update
     # @param replacements [Hash] Struct name replacement mapping
     def update_file_references(file_path, replacements)
         if File.exist?(file_path)
             begin
                 unless File.readable?(file_path)
                     return
                 end
                 
                 content = File.read(file_path)
                 original_content = content.dup
                 
                 replacements.each { |old_text, new_text| content.gsub!(old_text, new_text) }
                 
                 if content != original_content
                     unless File.writable?(file_path)
                         FileUtils.chmod('u+w', file_path)
                     end
                     
                     File.write(file_path, content)
                 end
             rescue => e
                 puts "  ⚠ Error processing #{File.basename(file_path)}: #{e.message}"
             end
         else
             puts "  ⚠ File not found: #{File.basename(file_path)} (will be processed on next pod install)"
         end
     end
     */
    
//    # Delete the OLD file on disk if present
//            begin
//                if File.exist?(mod[:old_path])
//                    begin
//                        FileUtils.chmod('u+w', mod[:old_path])
//                    rescue Errno::ENOENT
//                        # File vanished between exist? and chmod; ignore
//                    end
//                    FileUtils.rm_f(mod[:old_path])
//                    puts "Deleted old file on disk: #{File.basename(mod[:old_path])}"
//                end
//            rescue => e
//                puts "  ⚠ Failed to delete old file #{mod[:old_path]}: #{e.message}"
//            end
    
//    # Ensure membership in non-bundle 'Proto' targets' Compile Sources
//    proto_targets = installer.pods_project.targets.select { |t| t.display_name =~ /^Proto/ }
//    proto_resource_targets = installer.pods_project.targets.select { |t| t.display_name =~ /-Proto$/ }
//    proto_targets -= proto_resource_targets
//    for target in proto_targets
//        unless target.source_build_phase.files_references.include?(file_ref)
//        puts "Kungu: Adding file reference to #{file_ref.path}"
//        target.add_file_references([file_ref])
//        end
//        end
    
//    def update_xcode_references(installer, modifications)
//        modifications.each do |mod|
//            found = false
//            installer.pods_project.files.each do |file_ref|
//                if file_ref.path == mod[:old_rel] || file_ref.path == mod[:old_rel].sub(/^Proto\//, '')
//                    file_ref.set_path(mod[:new_rel])
//                    puts "Updated project reference: #{File.basename(mod[:old_rel])} → #{File.basename(mod[:new_rel])}"
//                    found = true
//                    break
//                end
//            end
//            unless found
//                puts "  ⚠ Could not find project reference for #{mod[:old_rel]}"
//            end
//        end
//        installer.pods_project.save
//    end

    /*
     Version - 3
        MARK: - Clean Up of V2
     
     # CustomSwiftProtobuf.rb
     # Public API: editSwiftProtobuf, updateWhiteBoardProtoFiles
     # All helper methods are private

     def editSwiftProtobuf(installer, namemap_computed_checksum, namemap_desired_checksum, enum_computed_checksum, enum_desired_checksum)
         # MARK: Edit NameMap.swift
         if !namemap_computed_checksum.eql? namemap_desired_checksum
             print "Modifying NameMap.swift\n"
             addCustomVarCount = '
     public extension _NameMap {
         /// Customised for use with Zoho Show iOS
         internal var count: Int {
             return numberToNameMap.count
         }
     }
             '

             name_map_file_path = Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/NameMap.swift'
             FileUtils.chmod('u+w', name_map_file_path)
             File.write('Pods/SwiftProtobuf/Sources/SwiftProtobuf/NameMap.swift', addCustomVarCount, mode: 'a+')
         end

         # MARK: Edit Enum.swift
         if !enum_computed_checksum.eql? enum_desired_checksum
             print "Modifying Enum.swift\n"
             enum_file_path = Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/Enum.swift'
             FileUtils.chmod('u+w', enum_file_path)
             system "sed -i '' 's/internal init?(name: String) {/public init?(name: String) {/g' \"#{enum_file_path}\""
         end

         #MARK: Add ShowExtensions.swift

         FileUtils.chmod('u+r', Dir.pwd + '/SwiftProtobufExtension/native/Extensions/ShowExtensions.swift')
         if File.exist?(Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/ShowExtensions.swift')
                 FileUtils.chmod('u+w', Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/ShowExtensions.swift')
                 FileUtils.remove_dir Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/ShowExtensions.swift'
         end

         # Copy ShowExtensions.swift to 'Pods/SwiftProtobuf/Sources/SwiftProtobuf' directory
         FileUtils.copy (Dir.pwd + '/SwiftProtobufExtension/native/Extensions/ShowExtensions.swift'), (Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf')

         # Add file reference to ShowExtensions.swift in SwiftProtobuf group
         file_ref = installer.pods_project.add_file_reference(
             Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/ShowExtensions.swift',
             installer.pods_project.pod_group('SwiftProtobuf'),
         )

         FileUtils.chmod('u+r', Dir.pwd + '/SwiftProtobufExtension/native/Extensions/DeltaDecoder.swift')
         if File.exist?(Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/DeltaDecoder.swift')
                 FileUtils.chmod('u+w', Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/DeltaDecoder.swift')
                 FileUtils.remove_dir Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/DeltaDecoder.swift'
         end

         # Copy DeltaDecoder.swift to 'Pods/SwiftProtobuf/Sources/SwiftProtobuf' directory
         FileUtils.copy (Dir.pwd + '/SwiftProtobufExtension/native/Extensions/DeltaDecoder.swift'), (Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf')

         # Add file reference to ShowExtensions.swift in SwiftProtobuf group
         file_ref1 = installer.pods_project.add_file_reference(
             Dir.pwd + '/Pods/SwiftProtobuf/Sources/SwiftProtobuf/DeltaDecoder.swift',
             installer.pods_project.pod_group('SwiftProtobuf'),
         )

         # Set target membership for ShowExtensions.swift
         swift_protobuf_targets = installer.pods_project.targets.select { |t| t.display_name =~ /^SwiftProtobuf/ } # Fetch all targets whose name begins with 'SwiftProtobuf'
         swift_protobuf_resource_targets = installer.pods_project.targets.select { |t| t.display_name =~ /-SwiftProtobuf$/ } # Fetch all targets whose name ends with '-SwiftProtobuf'. These are bundle targets
         swift_protobuf_targets -= swift_protobuf_resource_targets # Exclude bundle targets

         for target in swift_protobuf_targets
             target.add_file_references([file_ref, file_ref1])
         end
     end

     # Main function to rename duplicate proto files and update struct references
     # @param installer [Installer] CocoaPods installer instance
     def updateWhiteBoardProtoFiles(installer)
         puts "\n*** Renaming duplicate Proto files and structs ***\n"
         
         # Configuration: files to rename with their struct mappings
         file_configs = [
             {
                 rel_path: 'proto/share/whiteboard/custom.pb.swift',
                 new_name: 'whiteboard_custom.pb.swift',
                 old_struct: 'Custom',
                 new_struct: 'WhiteboardCustom'
             },
             {
                 rel_path: 'proto/whiteboard/document.pb.swift',
                 new_name: 'whiteboard_document.pb.swift',
                 old_struct: 'Document',
                 new_struct: 'WhiteboardDocument'
             },
             {
                 rel_path: 'proto/whiteboard/build/documentdata.pb.swift',
                 new_name: 'whiteboard_documentdata.pb.swift',
                 old_struct: 'DocumentData',
                 new_struct: 'WhiteboardDocumentData'
             }
         ]
         
         # Build modification configurations with generated replacements
         file_modifications = file_configs.map do |config|
             dir = File.dirname(config[:rel_path])
             old_rel = File.join('Proto', config[:rel_path])
             new_rel = File.join('Proto', dir, config[:new_name])
             
             {
                 old_path: proto_file_path(config[:rel_path]),
                 new_path: proto_file_path(File.join(dir, config[:new_name])),
                 old_rel: old_rel,
                 new_rel: new_rel,
                 struct_renames: generate_struct_replacements(config[:old_struct], config[:new_struct])
             }
         end
         
         # Step 1: Rename files and modify struct names
         file_modifications.each do |mod|
             rename_and_modify_file(mod[:old_path], mod[:new_path], mod[:struct_renames])
         end
         
         # Step 2: Update references in dependent files
         reference_updates = [
             {
                 file_path: proto_file_path('proto/whiteboard/build/projectdata.pb.swift'),
                 struct_renames: { '[DocumentData]' => '[WhiteboardDocumentData]' }
             },
             {
                 file_path: proto_file_path('proto/whiteboard/build/whiteboard_documentdata.pb.swift'),
                 struct_renames: generate_struct_replacements('Document', 'WhiteboardDocument')
                     .select { |k, _| k.match?(/\?\?|:.*\?|:.*\s/) }
             }
         ]
         
         reference_updates.each do |update|
             update_file_references(update[:file_path], update[:struct_renames])
         end
         
         puts "file_modifications Done Next step is xcode references"
         # Step 3: Update Xcode project references
         update_xcode_references(installer, file_modifications)
         
         puts "\n✓ All duplicate proto files have been renamed and struct names updated!"
         puts "  - Show versions: Use original names (Custom, Document, DocumentData)"
         puts "  - Whiteboard versions: Use prefixed names (WhiteboardCustom, WhiteboardDocument, WhiteboardDocumentData)"
     end

     # ============================================================================
     # Private Helper Methods
     # ============================================================================
     private

     # Generates standard Swift struct replacement patterns for renaming a type
     # @param old_name [String] Original struct name (e.g., 'Custom')
     # @param new_name [String] New struct name (e.g., 'WhiteboardCustom')
     # @return [Hash] Mapping of old patterns to new patterns
     def generate_struct_replacements(old_name, new_name)
         {
             "public struct #{old_name}" => "public struct #{new_name}",
             "struct #{old_name}:" => "struct #{new_name}:",
             "#{old_name}.self" => "#{new_name}.self",
             "#{old_name}." => "#{new_name}.",
             "#{old_name}:" => "#{new_name}:",
             "return #{old_name}(" => "return #{new_name}(",
             "var custom: #{old_name}" => "var custom: #{new_name}",
             ": #{old_name}?" => ": #{new_name}?",
             ": #{old_name} " => ": #{new_name} ",
             "(#{old_name}, #{old_name})" => "(#{new_name}, #{new_name})",
             "lhs: #{old_name}" => "lhs: #{new_name}",
             "rhs: #{old_name}" => "rhs: #{new_name}",
             "<#{old_name}>" => "<#{new_name}>",
             "[#{old_name}]" => "[#{new_name}]",
             " #{old_name}>" => " #{new_name}>",
             " #{old_name}," => " #{new_name},",
             "?? #{old_name}()" => "?? #{new_name}()"
         }
     end

     # Builds full file path from relative proto path
     # @param rel_path [String] Relative path under Proto directory
     # @return [String] Absolute file path
     def proto_file_path(rel_path)
         File.join(Dir.pwd, 'Pods', 'Proto', rel_path)
     end

     # Updates Xcode project file references
     # @param installer [Installer] CocoaPods installer instance
     # @param modifications [Array<Hash>] Array of file modification configs
     def update_xcode_references(installer, modifications)
         modifications.each do |mod|
             installer.pods_project.files.each do |file_ref|
                 if file_ref.path == mod[:old_rel]
                     file_ref.set_path(mod[:new_rel])
                     puts "Updated project reference: #{File.basename(mod[:old_rel])} → #{File.basename(mod[:new_rel])}"
                 end
             end
         end
         installer.pods_project.save
     end

     # Renames a file and applies struct name replacements
     # @param old_path [String] Original file path
     # @param new_path [String] New file path
     # @param replacements [Hash] Struct name replacement mapping
     def rename_and_modify_file(old_path, new_path, replacements)
         puts "Renaming and modifying file: #{File.basename(old_path)} → #{File.basename(new_path)}"
         return unless File.exist?(old_path)
         
         begin
             unless File.readable?(old_path)
                 puts "  ⚠ Skipping #{File.basename(old_path)}: File is not readable"
                 return
             end
             
             # Read and modify content
             content = File.read(old_path)
             replacements.each { |old_text, new_text| content.gsub!(old_text, new_text) }
             
             # Prepare file for rename
             FileUtils.chmod('u+w', old_path) unless File.writable?(old_path)
             
             # Rename and write
             File.rename(old_path, new_path)
             puts "Renamed file: #{File.basename(old_path)} → #{File.basename(new_path)}"
             
             FileUtils.chmod('u+w', new_path) if File.exist?(new_path)
             File.write(new_path, content)
             puts "  ✓ Updated struct names in #{File.basename(new_path)}"
         rescue => e
             puts "  ⚠ Error processing #{File.basename(old_path)}: #{e.message}"
         end
     end

     # Updates struct references in an existing file without renaming
     # @param file_path [String] Path to file to update
     # @param replacements [Hash] Struct name replacement mapping
     def update_file_references(file_path, replacements)
         if File.exist?(file_path)
             begin
                 unless File.readable?(file_path)
                     puts "  ⚠ Skipping #{File.basename(file_path)}: File is not readable"
                     return
                 end
                 
                 content = File.read(file_path)
                 original_content = content.dup
                 
                 replacements.each { |old_text, new_text| content.gsub!(old_text, new_text) }
                 
                 if content != original_content
                     unless File.writable?(file_path)
                         FileUtils.chmod('u+w', file_path)
                         puts "  ℹ Made #{File.basename(file_path)} writable"
                     end
                     
                     File.write(file_path, content)
                     puts "  ✓ Updated struct references in #{File.basename(file_path)}"
                 end
             rescue => e
                 puts "  ⚠ Error processing #{File.basename(file_path)}: #{e.message}"
             end
         else
             puts "  ⚠ File not found: #{File.basename(file_path)} (will be processed on next pod install)"
         end
     end
     */
    
    /*
     // Version - 2
     // MARK: - Post Install Working till file name, file class name changes and class name iterative changes.
     
     # CocoaPods Podfile

     source 'https://git.csez.zohocorpin.com/zohoshow/apple/public/specs.git'
     source 'https://repository.zohocorpcloud.in/zohocorp/zoho/zohopodspecs.git'
     source 'https://github.com/CocoaPods/Specs.git'

     platform :ios, '17.0'
      use_frameworks!
      
      target 'showXwhiteboard' do
        # Add your pods here, for example:
        use_frameworks!

        pod 'WhiteBoardiOS', :path => '/Users/kunguma-14252/Documents/ProtoConflict/WhiteboardiOS'
     #   pod 'WhiteBoardiOS', '1.0.5-beta1'
        pod 'ShowPreviewKit', '0.0.14'
        pod 'WhiteBoard', :path => '/Users/kunguma-14252/Documents/ProtoConflict/whiteboard_apple'
        
      end

     post_install do |installer|
         edit_swiftprotobuf_files(installer)
         rename_duplicate_proto_files(installer)
     end

     def rename_duplicate_proto_files(installer)
         # Rename duplicate proto files and their struct names to avoid conflicts
         puts "\n*** Renaming duplicate Proto files and structs ***\n"
         
         # Define files to rename: [old_path, new_path, old_rel_path, new_rel_path, struct_renames]
         file_modifications = [
             {
                 old_path: './Pods/Proto/proto/share/whiteboard/custom.pb.swift',
                 new_path: './Pods/Proto/proto/share/whiteboard/whiteboard_custom.pb.swift',
                 old_rel: 'Proto/proto/share/whiteboard/custom.pb.swift',
                 new_rel: 'Proto/proto/share/whiteboard/whiteboard_custom.pb.swift',
                 struct_renames: {
                     'public struct Custom' => 'public struct WhiteboardCustom',
                     'struct Custom:' => 'struct WhiteboardCustom:',
                     'Custom.self' => 'WhiteboardCustom.self',
                     'Custom.' => 'WhiteboardCustom.',
                     'Custom:' => 'WhiteboardCustom:',
                     'return Custom(' => 'return WhiteboardCustom(',
                     'var custom: Custom' => 'var custom: WhiteboardCustom',
                     ': Custom?' => ': WhiteboardCustom?',
                     ': Custom ' => ': WhiteboardCustom ',
                     '(Custom, Custom)' => '(WhiteboardCustom, WhiteboardCustom)',
                     'lhs: Custom' => 'lhs: WhiteboardCustom',
                     'rhs: Custom' => 'rhs: WhiteboardCustom',
                     '<Custom>' => '<WhiteboardCustom>',
                     '[Custom]' => '[WhiteboardCustom]',
                     ' Custom>' => ' WhiteboardCustom>',
                     ' Custom,' => ' WhiteboardCustom,'
                 }
             },
             {
                 old_path: './Pods/Proto/proto/whiteboard/document.pb.swift',
                 new_path: './Pods/Proto/proto/whiteboard/whiteboard_document.pb.swift',
                 old_rel: 'Proto/proto/whiteboard/document.pb.swift',
                 new_rel: 'Proto/proto/whiteboard/whiteboard_document.pb.swift',
                 struct_renames: {
                     'public struct Document' => 'public struct WhiteboardDocument',
                     'struct Document:' => 'struct WhiteboardDocument:',
                     'Document.self' => 'WhiteboardDocument.self',
                     'Document.' => 'WhiteboardDocument.',
                     'Document:' => 'WhiteboardDocument:',
                     'return Document(' => 'return WhiteboardDocument(',
                     ': Document?' => ': WhiteboardDocument?',
                     ': Document ' => ': WhiteboardDocument ',
                     '(Document, Document)' => '(WhiteboardDocument, WhiteboardDocument)',
                     'lhs: Document' => 'lhs: WhiteboardDocument',
                     'rhs: Document' => 'rhs: WhiteboardDocument',
                     '<Document>' => '<WhiteboardDocument>',
                     '[Document]' => '[WhiteboardDocument]',
                     ' Document>' => ' WhiteboardDocument>',
                     ' Document,' => ' WhiteboardDocument,'
                 }
             },
             {
                 old_path: './Pods/Proto/proto/whiteboard/build/documentdata.pb.swift',
                 new_path: './Pods/Proto/proto/whiteboard/build/whiteboard_documentdata.pb.swift',
                 old_rel: 'Proto/proto/whiteboard/build/documentdata.pb.swift',
                 new_rel: 'Proto/proto/whiteboard/build/whiteboard_documentdata.pb.swift',
                 struct_renames: {
                     'public struct DocumentData' => 'public struct WhiteboardDocumentData',
                     'struct DocumentData:' => 'struct WhiteboardDocumentData:',
                     'DocumentData.self' => 'WhiteboardDocumentData.self',
                     'DocumentData.' => 'WhiteboardDocumentData.',
                     'DocumentData:' => 'WhiteboardDocumentData:',
                     'return DocumentData(' => 'return WhiteboardDocumentData(',
                     ': DocumentData?' => ': WhiteboardDocumentData?',
                     ': DocumentData ' => ': WhiteboardDocumentData ',
                     '(DocumentData, DocumentData)' => '(WhiteboardDocumentData, WhiteboardDocumentData)',
                     'lhs: DocumentData' => 'lhs: WhiteboardDocumentData',
                     'rhs: DocumentData' => 'rhs: WhiteboardDocumentData',
                     '<DocumentData>' => '<WhiteboardDocumentData>',
                     '[DocumentData]' => '[WhiteboardDocumentData]',
                     ' DocumentData>' => ' WhiteboardDocumentData>',
                     ' DocumentData,' => ' WhiteboardDocumentData,'
                 }
             }
         ]
         
         # Step 1: Update Xcode project references
         file_modifications.each do |mod|
             installer.pods_project.files.each do |file_ref|
                 if file_ref.path == mod[:old_rel]
                     file_ref.set_path(mod[:new_rel])
                     puts "Updated project reference: #{File.basename(mod[:old_rel])} → #{File.basename(mod[:new_rel])}"
                 end
             end
         end
         
         # Save the project with updated references
         installer.pods_project.save
         
         # Step 2: Rename files and modify struct names
         file_modifications.each do |mod|
             if File.exist?(mod[:old_path])
                 begin
                     # Check if file is readable
                     unless File.readable?(mod[:old_path])
                         puts "  ⚠ Skipping #{File.basename(mod[:old_path])}: File is not readable"
                         next
                     end
                     
                     # Read the file content
                     content = File.read(mod[:old_path])
                     
                     # Apply struct name replacements
                     mod[:struct_renames].each do |old_text, new_text|
                         content.gsub!(old_text, new_text)
                     end
                     
                     # Make file writable if it's read-only (needed for rename)
                     unless File.writable?(mod[:old_path])
                         File.chmod(0644, mod[:old_path])
                     end
                     
                     # Rename the file
                     File.rename(mod[:old_path], mod[:new_path])
                     puts "Renamed file: #{File.basename(mod[:old_path])} → #{File.basename(mod[:new_path])}"
                     
                     # Ensure new file is writable before writing
                     File.chmod(0644, mod[:new_path]) if File.exist?(mod[:new_path])
                     
                     # Write the modified content
                     File.write(mod[:new_path], content)
                     puts "  ✓ Updated struct names in #{File.basename(mod[:new_path])}"
                 rescue => e
                     puts "  ⚠ Error processing #{File.basename(mod[:old_path])}: #{e.message}"
                 end
             end
         end
         
         # Step 3: Process files that reference renamed structs but don't need renaming
         # These files use the renamed structs and need their references updated
         reference_updates = [
             {
                 file_path: './Pods/Proto/proto/whiteboard/build/projectdata.pb.swift',
                 struct_renames: {
                     '[DocumentData]' => '[WhiteboardDocumentData]'
                 }
             },
             {
                 file_path: './Pods/Proto/proto/whiteboard/build/whiteboard_documentdata.pb.swift',
                 struct_renames: {
                     ' Document?' => 'WhiteboardDocument?',
                     '?? Document()' => '?? WhiteboardDocument()',
                     ': Document ' => ': WhiteboardDocument ',
                     ': Document?' => ': WhiteboardDocument?'
                 }
             }
         ]
         
         reference_updates.each do |update|
             file_path = update[:file_path]
             if File.exist?(file_path)
                 begin
                     # Check if file is readable
                     unless File.readable?(file_path)
                         puts "  ⚠ Skipping #{File.basename(file_path)}: File is not readable"
                         next
                     end
                     
                     content = File.read(file_path)
                     original_content = content.dup
                     
                     # Apply struct name replacements
                     update[:struct_renames].each do |old_text, new_text|
                         content.gsub!(old_text, new_text)
                     end
                     
                     # Only write if content changed
                     if content != original_content
                         # Make file writable if it's read-only
                         unless File.writable?(file_path)
                             File.chmod(0644, file_path)
                             puts "  ℹ Made #{File.basename(file_path)} writable"
                         end
                         
                         File.write(file_path, content)
                         puts "  ✓ Updated struct references in #{File.basename(file_path)}"
                     end
                 rescue => e
                     puts "  ⚠ Error processing #{File.basename(file_path)}: #{e.message}"
                 end
             else
                 puts "  ⚠ File not found: #{File.basename(file_path)} (will be processed on next pod install)"
             end
         end
         
         puts "\n✓ All duplicate proto files have been renamed and struct names updated!"
         puts "  - Show versions: Use original names (Custom, Document, DocumentData)"
         puts "  - Whiteboard versions: Use prefixed names (WhiteboardCustom, WhiteboardDocument, WhiteboardDocumentData)"
     end

     def edit_swiftprotobuf_files(installer)
         # Add SwiftProtobuf Extensions
         namemap_computed_checksum = `md5 -q ./Pods/SwiftProtobuf/Sources/SwiftProtobuf/NameMap.swift`
         namemap_desired_checksum = "7c174a92e0de3b1a1d5cfce720c08337\n"
         enum_computed_checksum = `md5 -q ./Pods/SwiftProtobuf/Sources/SwiftProtobuf/Enum.swift`
         enum_desired_checksum = "7cc973a47230f2d39df918f885f27b9a\n"
         
         #check if SwiftProtobufExtension was already added
         if (!namemap_computed_checksum.eql? namemap_desired_checksum) || (!enum_computed_checksum.eql? enum_desired_checksum)
             puts "\n*** Swift Protobuf Extensions ***\n"
             if File.exist?('SwiftProtobufExtension')
                 FileUtils.remove_dir 'SwiftProtobufExtension'
             end
             system 'git clone https://git.csez.zohocorpin.com/zohoshow/apple/public/SwiftProtobufExtension.git'
             require_relative 'SwiftProtobufExtension/native/CustomSwiftProtobuf'
             editSwiftProtobuf(installer, namemap_computed_checksum, namemap_desired_checksum, enum_computed_checksum, enum_desired_checksum)
             FileUtils.remove_dir 'SwiftProtobufExtension'
         end
     end

     */

    
    
    /*
     // Version - 1
     // MARK: - Post Install Working till file name and file class name changes.
     # CocoaPods Podfile

     source 'https://git.csez.zohocorpin.com/zohoshow/apple/public/specs.git'
     source 'https://repository.zohocorpcloud.in/zohocorp/zoho/zohopodspecs.git'
     source 'https://github.com/CocoaPods/Specs.git'

     platform :ios, '17.0'
      use_frameworks!
      
      target 'showXwhiteboard' do
        # Add your pods here, for example:
        use_frameworks!

        pod 'WhiteBoardiOS', :path => '/Users/kunguma-14252/Documents/ProtoConflict/WhiteboardiOS'
     #   pod 'WhiteBoardiOS', '1.0.5-beta1'
        pod 'ShowPreviewKit', '0.0.14'
        pod 'WhiteBoard', :path => '/Users/kunguma-14252/Documents/ProtoConflict/whiteboard_apple'
        
      end

     post_install do |installer|
         edit_swiftprotobuf_files(installer)
         rename_duplicate_proto_files(installer)
     end

     def rename_duplicate_proto_files(installer)
         # Rename duplicate proto files and their struct names to avoid conflicts
         puts "\n*** Renaming duplicate Proto files and structs ***\n"
         
         # Define files to rename: [old_path, new_path, old_rel_path, new_rel_path, struct_renames]
         file_modifications = [
             {
                 old_path: './Pods/Proto/proto/share/whiteboard/custom.pb.swift',
                 new_path: './Pods/Proto/proto/share/whiteboard/whiteboard_custom.pb.swift',
                 old_rel: 'Proto/proto/share/whiteboard/custom.pb.swift',
                 new_rel: 'Proto/proto/share/whiteboard/whiteboard_custom.pb.swift',
                 struct_renames: {
                     'public struct Custom' => 'public struct WhiteboardCustom',
                     'struct Custom:' => 'struct WhiteboardCustom:',
                     'Custom.self' => 'WhiteboardCustom.self',
                     'Custom.' => 'WhiteboardCustom.',
                     'Custom:' => 'WhiteboardCustom:',
                     'return Custom(' => 'return WhiteboardCustom(',
                     'var custom: Custom' => 'var custom: WhiteboardCustom',
                     ': Custom?' => ': WhiteboardCustom?',
                     ': Custom ' => ': WhiteboardCustom ',
                     '(Custom, Custom)' => '(WhiteboardCustom, WhiteboardCustom)',
                     'lhs: Custom' => 'lhs: WhiteboardCustom',
                     'rhs: Custom' => 'rhs: WhiteboardCustom',
                     '<Custom>' => '<WhiteboardCustom>',
                     '[Custom]' => '[WhiteboardCustom]',
                     ' Custom>' => ' WhiteboardCustom>',
                     ' Custom,' => ' WhiteboardCustom,'
                 }
             },
             {
                 old_path: './Pods/Proto/proto/whiteboard/document.pb.swift',
                 new_path: './Pods/Proto/proto/whiteboard/whiteboard_document.pb.swift',
                 old_rel: 'Proto/proto/whiteboard/document.pb.swift',
                 new_rel: 'Proto/proto/whiteboard/whiteboard_document.pb.swift',
                 struct_renames: {
                     'public struct Document' => 'public struct WhiteboardDocument',
                     'struct Document:' => 'struct WhiteboardDocument:',
                     'Document.self' => 'WhiteboardDocument.self',
                     'Document.' => 'WhiteboardDocument.',
                     'Document:' => 'WhiteboardDocument:',
                     'return Document(' => 'return WhiteboardDocument(',
                     ': Document?' => ': WhiteboardDocument?',
                     ': Document ' => ': WhiteboardDocument ',
                     '(Document, Document)' => '(WhiteboardDocument, WhiteboardDocument)',
                     'lhs: Document' => 'lhs: WhiteboardDocument',
                     'rhs: Document' => 'rhs: WhiteboardDocument',
                     '<Document>' => '<WhiteboardDocument>',
                     '[Document]' => '[WhiteboardDocument]',
                     ' Document>' => ' WhiteboardDocument>',
                     ' Document,' => ' WhiteboardDocument,'
                 }
             },
             {
                 old_path: './Pods/Proto/proto/whiteboard/build/documentdata.pb.swift',
                 new_path: './Pods/Proto/proto/whiteboard/build/whiteboard_documentdata.pb.swift',
                 old_rel: 'Proto/proto/whiteboard/build/documentdata.pb.swift',
                 new_rel: 'Proto/proto/whiteboard/build/whiteboard_documentdata.pb.swift',
                 struct_renames: {
                     'public struct DocumentData' => 'public struct WhiteboardDocumentData',
                     'struct DocumentData:' => 'struct WhiteboardDocumentData:',
                     'DocumentData.self' => 'WhiteboardDocumentData.self',
                     'DocumentData.' => 'WhiteboardDocumentData.',
                     'DocumentData:' => 'WhiteboardDocumentData:',
                     'return DocumentData(' => 'return WhiteboardDocumentData(',
                     ': DocumentData?' => ': WhiteboardDocumentData?',
                     ': DocumentData ' => ': WhiteboardDocumentData ',
                     '(DocumentData, DocumentData)' => '(WhiteboardDocumentData, WhiteboardDocumentData)',
                     'lhs: DocumentData' => 'lhs: WhiteboardDocumentData',
                     'rhs: DocumentData' => 'rhs: WhiteboardDocumentData',
                     '<DocumentData>' => '<WhiteboardDocumentData>',
                     '[DocumentData]' => '[WhiteboardDocumentData]',
                     ' DocumentData>' => ' WhiteboardDocumentData>',
                     ' DocumentData,' => ' WhiteboardDocumentData,'
                 }
             }
         ]
         
         # Step 1: Update Xcode project references
         file_modifications.each do |mod|
             installer.pods_project.files.each do |file_ref|
                 if file_ref.path == mod[:old_rel]
                     file_ref.set_path(mod[:new_rel])
                     puts "Updated project reference: #{File.basename(mod[:old_rel])} → #{File.basename(mod[:new_rel])}"
                 end
             end
         end
         
         # Save the project with updated references
         installer.pods_project.save
         
         # Step 2: Rename files and modify struct names
         file_modifications.each do |mod|
             if File.exist?(mod[:old_path])
                 # Read the file content
                 content = File.read(mod[:old_path])
                 
                 # Apply struct name replacements
                 mod[:struct_renames].each do |old_text, new_text|
                     content.gsub!(old_text, new_text)
                 end
                 
                 # Rename the file
                 File.rename(mod[:old_path], mod[:new_path])
                 puts "Renamed file: #{File.basename(mod[:old_path])} → #{File.basename(mod[:new_path])}"
                 
                 # Write the modified content
                 File.write(mod[:new_path], content)
                 puts "  ✓ Updated struct names in #{File.basename(mod[:new_path])}"
             end
         end
         
         puts "\n✓ All duplicate proto files have been renamed and struct names updated!"
         puts "  - Show versions: Use original names (Custom, Document, DocumentData)"
         puts "  - Whiteboard versions: Use prefixed names (WhiteboardCustom, WhiteboardDocument, WhiteboardDocumentData)"
     end

     def edit_swiftprotobuf_files(installer)
         # Add SwiftProtobuf Extensions
         namemap_computed_checksum = `md5 -q ./Pods/SwiftProtobuf/Sources/SwiftProtobuf/NameMap.swift`
         namemap_desired_checksum = "7c174a92e0de3b1a1d5cfce720c08337\n"
         enum_computed_checksum = `md5 -q ./Pods/SwiftProtobuf/Sources/SwiftProtobuf/Enum.swift`
         enum_desired_checksum = "7cc973a47230f2d39df918f885f27b9a\n"
         
         #check if SwiftProtobufExtension was already added
         if (!namemap_computed_checksum.eql? namemap_desired_checksum) || (!enum_computed_checksum.eql? enum_desired_checksum)
             puts "\n*** Swift Protobuf Extensions ***\n"
             if File.exist?('SwiftProtobufExtension')
                 FileUtils.remove_dir 'SwiftProtobufExtension'
             end
             system 'git clone https://git.csez.zohocorpin.com/zohoshow/apple/public/SwiftProtobufExtension.git'
             require_relative 'SwiftProtobufExtension/native/CustomSwiftProtobuf'
             editSwiftProtobuf(installer, namemap_computed_checksum, namemap_desired_checksum, enum_computed_checksum, enum_desired_checksum)
             FileUtils.remove_dir 'SwiftProtobufExtension'
         end
     end

     */
}
