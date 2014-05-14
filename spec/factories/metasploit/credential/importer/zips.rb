FactoryGirl.define do
  factory :metasploit_credential_importer_zip do
    zip_file { generate :metasploit_credential_importer_zip_file }
  end

  #
  # Create a zip with keys and manifest
  #
  sequence :metasploit_credential_importer_zip_file do |n|
    path = "#{Rails.root}/tmp/#{Metasploit::Credential::Importer::Zip::ZIP_DIRECTORY_PREFIX}-#{Time.now.to_i}-#{n}"
    FileUtils.mkdir_p(path)

    # Create keys
    key_data = 5.times.collect do
      FactoryGirl.build(:metasploit_credential_ssh_key).data
    end

    # associate keys with usernames
    csv_hash = key_data.inject({}) do |hash, data|
      username = FactoryGirl.generate(:metasploit_credential_public_username)
      hash[username] = data
      hash
    end

    # write out each key into a file in the intended zip directory
    csv_hash.each do |name, ssh_key_data|
      File.open("#{path}/#{name}", 'w') do |file|
        file << ssh_key_data
      end
    end

    # write out manifest CSV into the zip directory
    CSV.open("#{path}/#{Metasploit::Credential::Importer::CSV::Manifest::MANIFEST_FILE_NAME}", 'wb') do |csv|
      csv << Metasploit::Credential::Importer::CSV::Manifest::VALID_CSV_HEADERS
      csv_hash.keys.each do |key|
        csv << [key, key]
      end
    end

    # Write out zip file
    zip_location = "#{path}.zip"
    Zip::File.open(zip_location, Zip::File::CREATE) do |zipfile|
      Dir.entries(path).each do |entry|
        next if entry.first == '.'
        zipfile.add(entry, path + '/' + entry)
      end
    end
  end
end

