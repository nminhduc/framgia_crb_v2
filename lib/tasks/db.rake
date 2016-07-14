namespace :db do
  desc "remake database data"
  task remake_data: :environment do

    if Rails.env.production?
      puts "Not running in 'Production' task"
    else
      %w[db:drop db:create db:migrate db:seed db:test:prepare].each do |task|
        Rake::Task[task].invoke
      end

      puts "Create permission"
      Fabricate :permission, permission: I18n.t("permissions.permission_1")
      Fabricate :permission, permission: I18n.t("permissions.permission_2")
      Fabricate :permission, permission: I18n.t("permissions.permission_3")
      Fabricate :permission, permission: I18n.t("permissions.permission_4")

      Fabricate :notification, notification_type:
        I18n.t("events.notification.email")
      Fabricate :notification, notification_type:
        I18n.t("events.notification.chatwork")
      Fabricate :notification, notification_type:
        I18n.t("events.notification.desktop")

      user_hash = {
        "Khong Minh Tri": "khong.minh.tri",
        "Bui Quoc Viet": "bui.quoc.viet",
        "Hoang Thi Nhung": "hoang.thi.nhung",
        "Nguyen Binh Dieu": "nguyen.binh.dieu",
        "Tran Quang Trung": "tran.quang.trung",
        "Dao Duy Dat": "dao.duy.dat",
        "Nguyen Thai Son": "nguyen.thai.son",
        "Lim Kimhuor": "lim.kimhuor",
        "Chu Anh Tuan": "chu.anh.tuan",
        "Ngo Thai Minh": "ngo.thai.minh",
        "Mai Dinh Phu": "mai.dinh.phu",
        "Nguyen Quang Duy": "nguyen.quang.duy"
      }

      puts "Creating Color, User, Calendar, Share calendar, Event"

      Settings.colors.each do |color|
        Fabricate :color, color_hex: color
      end

      Settings.event.repeat_data.each do |date|
        Fabricate :days_of_week, name: date
      end

      user_hash.each do |key, value|
        user = Fabricate :user, name: key, email: value+"@framgia.com"
        calendar = user.calendars.first

        date_time = DateTime.now
        start_time_day = date_time.change({hour: 8})
        end_time_day = date_time.change({hour: 10})
        range = Random.rand(20...30)
        end_repeat = date_time + range.days

        event = Fabricate :event, title: "Framgia CRB Meeting",
          start_date: start_time_day, finish_date: end_time_day,
          start_repeat: date_time, end_repeat: end_repeat,
          calendar_id: calendar.id, user_id: user.id,
          repeat_type: 1, repeat_every: 1

        if event.weekly?
          3.times{Fabricate :repeat_on, event_id: event.id, days_of_week_id: rand(1..7)}
        end

      end
    end
  end
end
