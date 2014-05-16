FactoryGirl.define do
  factory :metasploit_credential_zip_importer_manifest_well_formed_compliant,
          class: Metasploit::Credential::Importer::CSV::Manifest  do

    origin_import { FactoryGirl.build :metasploit_credential_origin_import }
    data { generate :well_formed_csv_manifest_io }
  end

  sequence :well_formed_csv_manifest_io do |n|
    csv_string =<<-eos

    eos
  end
end