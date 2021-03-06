require 'faker'

ActiveRecord::Base.transaction do
  puts "Seeding database"

  # Populate Countries and Languages
  Rake::Task['populate_countries'].invoke
  Rake::Task['populate_languages'].invoke

  # NY Region
  ny_region = Region.create!(name: 'ny')

  # Florida Region
  fl_region = Region.create!(name: 'fl')

  # Primary community (NYC)
  nyc_community = Community.create!(name: 'NYC',
                                  slug: 'nyc',
                                  region_id: ny_region.id,
                                  primary: true)

  # NON-primary community (Long Island)
  long_island_community = Community.create!(name: 'Long Island',
                                          slug: 'long-island',
                                          region_id: ny_region.id,
                                          primary: false)

  # Primary community (Tampa)
  tampa_community = Community.create!(name: 'Tampa',
                                  slug: 'tampa',
                                  region_id: fl_region.id,
                                  primary: true)

  # NY Regional admin
  ny_regional_admin = User.create!(first_name: 'NY Regional', last_name: 'Admin', email: 'ny_regional_admin@example.com', community_id: nyc_community.id, phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 2, pledge_signed: true)
  ny_regional_admin.user_regions.create!(region_id: ny_region.id)

  ## NYC Users

  #Accompaniment Leader User
  User.create!(first_name: 'NYC Accompaniment', last_name: 'Leader', email: 'nyc_accompaniment_leader@example.com', community_id: nyc_community.id, phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 1, pledge_signed: true)

  #Volunteer User
  User.create!(first_name: 'NYC Community', last_name: 'Volunteer', email: 'nyc_volunteer@example.com', community_id: nyc_community.id, phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 0, pledge_signed: true)

  #Admin User
  User.create!(first_name: 'NYC Community', last_name: 'Admin', email: 'nyc_admin@example.com', community_id: nyc_community.id, phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 2, pledge_signed: true)

  #Remote Clinic Lawyer
  User.create!(first_name: 'Remote Clinic', last_name: 'Lawyer', email: 'remote_clinic_lawyer@example.com', community_id: nyc_community.id, phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 2, role: 0, pledge_signed: true, remote_clinic_lawyer: true)

  #Some additional NYC volunteer users
  20.times do
    User.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.safe_email, community_id: nyc_community.id, phone: Faker::PhoneNumber.phone_number, password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 0, pledge_signed: true)
  end

  10.times do
    User.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.safe_email, community_id: nyc_community.id, phone: Faker::PhoneNumber.phone_number, password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 2, role: 0, pledge_signed: true, remote_clinic_lawyer: false)
  end
  ## Long Island Users

  #Accompaniment Leader User
  User.create!(first_name: 'LI Accompaniment', last_name: 'Leader', email: 'li_accompaniment_leader@example.com', community_id: long_island_community.id, phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 1, pledge_signed: true)

  #Volunteer User
  User.create!(first_name: 'LI Community', last_name: 'Volunteer', email: 'li_volunteer@example.com', community_id: long_island_community.id, phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 0, pledge_signed: true)

  #Admin User
  User.create!(first_name: 'LI Community', last_name: 'Admin', email: 'li_admin@example.com', community_id: long_island_community.id, phone: '888 888 8888', password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 2, pledge_signed: true)


  #Some additional Long Island volunteer users
  30.times do
    User.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.safe_email, community_id: long_island_community.id, phone: Faker::PhoneNumber.phone_number, password: 'Password1234', password_confirmation: 'Password1234', invitation_accepted_at: Time.now, volunteer_type: 1, role: 0, pledge_signed: true)
  end

  # NYC Friends
  30.times do
    Friend.create!(first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      a_number: rand.to_s[2..10],
      community_id: nyc_community.id,
      region_id: ny_region.id,
      middle_name: Faker::Name.first_name,
      email: Faker::Internet.safe_email,
      phone: Faker::PhoneNumber.phone_number,
      ethnicity: ['white', 'black', 'hispanic', 'asian', 'south_asian', 'caribbean', 'indigenous'].sample,
      gender: ['male', 'female', 'awesome'].sample,
      date_of_birth: Faker::Time.between(10.years.ago, 40.years.ago),
      status: 'not_in_deportation_proceedings',
      date_of_entry: Faker::Time.between(1.day.ago, 5.years.ago),
      notes: Faker::Lorem.paragraph,
      asylum_status: ['not_eligible', 'eligible', 'application_started'].sample,
      asylum_notes: Faker::Lorem.paragraph,
      lawyer_notes: Faker::Lorem.paragraph,
      work_authorization_notes: Faker::Lorem.paragraph,
      work_authorization_status: ['not_eligible', 'eligible', 'application_started'].sample,
      sijs_status: ['not_eligible', 'eligible', 'application_started'].sample,
      sijs_notes: Faker::Lorem.paragraph,
      country_id: Country.order("RANDOM()").first.id,
      language_ids: [Language.order("RANDOM()").first.id],
      user_ids: User.where(community_id: nyc_community.id).order("RANDOM()").limit(5).map(&:id)
      )
  end

  # Long Islang Friends
  30.times do
    friend = Friend.create!(first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      a_number: rand.to_s[2..10],
      community_id: long_island_community.id,
      region_id: ny_region.id,
      middle_name: Faker::Name.first_name,
      email: Faker::Internet.safe_email,
      phone: Faker::PhoneNumber.phone_number,
      ethnicity: ['white', 'black', 'hispanic', 'asian', 'south_asian', 'caribbean', 'indigenous'].sample,
      gender: ['male', 'female', 'awesome'].sample,
      date_of_birth: Faker::Time.between(10.years.ago, 40.years.ago),
      status: 'not_in_deportation_proceedings',
      date_of_entry: Faker::Time.between(10.years.ago, 40.years.ago),
      notes: Faker::Lorem.paragraph,
      asylum_status: ['not_eligible', 'eligible', 'application_started'].sample,
      asylum_notes: Faker::Lorem.paragraph,
      lawyer_notes: Faker::Lorem.paragraph,
      work_authorization_notes: Faker::Lorem.paragraph,
      work_authorization_status: ['not_eligible', 'eligible', 'application_started'].sample,
      sijs_status: ['not_eligible', 'eligible', 'application_started'].sample,
      sijs_notes: Faker::Lorem.paragraph,
      country_id: Country.order("RANDOM()").first.id,
      language_ids: [Language.order("RANDOM()").first.id],
      user_ids: User.where(community_id: long_island_community.id).order("RANDOM()").limit(5).map(&:id)
      )
  end

  #Lawyers
  Lawyer.create!(first_name: 'Michelle', last_name: 'Obama', region_id: ny_region.id)
  Lawyer.create!(first_name: 'Arrabella', last_name: 'Mansfield', region_id: ny_region.id)
  Lawyer.create!(first_name: 'Amal', last_name: 'Clooney', region_id: ny_region.id)
  Lawyer.create!(first_name: 'Hillary', last_name: 'Rodham', region_id: ny_region.id)

  #Locations
  Location.create!(name: '26 Federal Plaza', region_id: ny_region.id)
  Location.create!(name: 'Judson', region_id: ny_region.id)
  Location.create!(name: 'Varick St', region_id: ny_region.id)

  #Judges
  Judge.create!(first_name: 'Ruth', last_name: 'Bader Ginsburg', region_id: ny_region.id)
  Judge.create!(first_name: 'Sonia', last_name: 'Sotomayor', region_id: ny_region.id)
  Judge.create!(first_name: 'Elena', last_name: 'Kagan', region_id: ny_region.id)

  #ActivityType
  hearing = ActivityType.create!(name: "Hearing", cap: 0, accompaniment_eligible: false)
  check_in = ActivityType.create!(name: "Check In", cap: 3, accompaniment_eligible: true)

  #Activities
  Friend.all.each do |friend|
    friend.activities.create!(
      event: ['check_in', 'master_calendar_hearing', 'individual_hearing'].sample,
      location_id: Location.first.id,
      judge_id: Judge.first.id,
      occur_at: Faker::Time.between(1.month.ago, 1.month.from_now),
      notes: Faker::Lorem.paragraph,
      confirmed: true,
      region_id: ny_region.id,
      activity_type: [hearing, check_in].sample)
  end

  ##Accompaniments
  Activity.where('activity_type_id = ?', check_in.id).each do |activity|
    activity.accompaniments.create!(user_id: User.where(community_id: nyc_community.id).order("RANDOM()").first.id)
  end

  #Events
  30.times do |t|
    Event.create!(location: Location.order("RANDOM()").first,
                category: Event::CATEGORIES.sample[0],
                date: Faker::Time.between(2.months.ago, 2.months.from_now),
                title: "Test Event #{t}",
                community_id: nyc_community.id)
  end

  Event.all.each do |event|
    event.user_event_attendances.create!(user_id: User.where(community_id: nyc_community.id).order("RANDOM()").first.id)
    event.friend_event_attendances.create!(friend_id: Friend.where(community_id: nyc_community.id).order("RANDOM()").first.id)
  end

  #Detentions
  Friend.all[0..25].each_with_index do |friend, index|
    is_released = index % 5 == 0
    date_released = is_released ? Faker::Time.between(1.month.from_now, 1.month.ago) : nil
    friend.detentions.create!(
      date_detained: Faker::Time.between(8.months.ago, 7.months.ago),
      date_released: date_released,
      case_status: ['immigration_court', 'bia', 'circuit_court'].sample,
      location_id: Location.last.id,
      notes: Faker::Lorem.paragraph
    )
  end

  #Sanctuaries
  10.times do
    Sanctuary.create!(name: Faker::Company.name,
                      address: Faker::Address.street_address,
                      city: 'New York',
                      state: 'NY',
                      zip_code: '10001',
                      leader_name:  Faker::Name.name,
                      leader_email: Faker::Internet.safe_email,
                      leader_phone_number: Faker::PhoneNumber.phone_number,
                      community_id: nyc_community.id)
  end
end
