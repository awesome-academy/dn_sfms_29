require "rails_helper"

describe "bookings/new.html.erb" do
  let(:user){FactoryBot.create :user, role: 1}
  let(:subpitch_type){FactoryBot.create :subpitch_type}
  let(:pitch){FactoryBot.create :pitch, user_id: user.id}
  let(:subpitch) do
    @subpitch =
      FactoryBot.create :subpitch, pitch_id: pitch.id,
                                   subpitch_type_id: subpitch_type.id
  end
  let(:booking) do
    FactoryBot.create :booking, user_id: user.id, subpitch_id: subpitch.id
  end
  before(case: :has_bookings) do
    @bookings = [booking]
  end
  before(case: :have_not_bookings) do
    @subpitch = Subpitch.new id: 1, pitch_id: 1
  end

  before do
    @schedule_details =
      [["04:00", "05:00", "pasttime"], ["05:00", "06:00", "pasttime"],
      ["06:00", "07:00", "pasttime"], ["07:00", "08:00", "pasttime"],
      ["08:00", "09:00", "pasttime"], ["09:00", "10:00", "pasttime"],
      ["10:00", "11:00", true], ["11:00", "12:00", true], ["12:00", "13:00"],
      ["13:00", "14:00"], ["14:00", "15:00"], ["15:00", "16:00"],
      ["16:00", "17:00"]]
    render
  end

  context "when has bookings", case: :has_bookings do
    it do
      rendered.should have_selector "div",
        class: "schedule"
    end

    it do
      rendered.should_not have_selector "div",
        class: "schedule p-40px"
    end

    it do
      rendered.should have_selector "div",
        class: "col-md-5 p-top-150px form-schedule"
    end

    it "displays detail bookings correctly" do
      rendered.should have_selector "table.table.table-hover.table-dark
        tbody tr:nth-of-type(1) td:nth-of-type(1)", text: "#{pitch.name}"
    end

    it "displays detail bookings correctly" do
      rendered.should have_selector "table.table.table-hover.table-dark
        tbody tr:nth-of-type(1) td:nth-of-type(2)", text: "#{subpitch.name}"
    end

    it "displays checkbox-inputs" do
      rendered.should have_selector "input[value=" +
        "\"#{@schedule_details[6][0]}\"]"
    end

    it "displays time periods in schedule" do
      rendered.should have_selector "span",
        text: "#{@schedule_details[6][0]} " +
        "#{I18n.t("bookings.new.to")} #{@schedule_details[7][0]}"
    end

    it "displays button to book" do
      rendered.should have_selector "input[value=" +
        "\"#{I18n.t "helpers.submit.booking.submit"}\"]",
        class: "btn btn-primary"
    end
  end

  context "when haven't bookings", case: :have_not_bookings do
    it do
      rendered.should_not have_selector "h1", class: "center",
        text: I18n.t("bookings.new.history_booking")
    end

    it do
      rendered.should have_selector "div",
        class: "schedule p-40px"
    end

    it do
      rendered.should have_selector "div",
        class: "col-md-6 p-top-150px form-schedule"
    end

    it "displays checkbox-inputs" do
      rendered.should have_selector "input[value=" +
      "\"#{@schedule_details[6][0]}\"]"
    end

    it "displays time periods in schedule" do
      rendered.should have_selector "span",
        text: "#{@schedule_details[6][0]} " +
        "#{I18n.t("bookings.new.to")} #{@schedule_details[7][0]}"
    end

    it "displays button to book" do
      rendered.should have_selector "input[value=" +
        "\"#{I18n.t "helpers.submit.booking.submit"}\"]",
        class: "btn btn-primary"
    end
  end
end
