class PDFWriter

  attr_reader :user, :content_type, :pdf

  HEADERS = ["TIME", "DATE", "TEMP INSIDE", "TEMP OUTSIDE", "TEMP OF HOT WATER", "NOTES"]
  HEADER_OPTIONS = {width: 90, background_color: "AFAFAF", align: :center, font_style: :bold, border_width: 0.5}
  FONT = "Times-Roman"
  FONT_OPTIONS = {size: 7, align: :center}
  TABLE_OPTIONS = {width: 90, align: :center, border_width: 0.5}

  def initialize(user)
    @user = user
    @content_type = "application/pdf"
    @pdf = Prawn::Document.new
  end

  def self.new_from_user_id(user_id)
    new(User.find(user_id))
  end

  def generate_pdf
    populate_pdf
    pdf.render
  end

  def filename
    "#{user.last_name}.pdf"
  end

  def populate_pdf
    image_url = Rails.root.join("app","assets","images","pdf_header.png")
    pdf.text "Tenant: #{self.user.name}"
    pdf.image image_url, width: 550
    pdf.move_down 5
    pdf.font FONT, FONT_OPTIONS
    pdf.table [HEADERS], cell_style: HEADER_OPTIONS
    pdf.table self.user.table_array, cell_style: TABLE_OPTIONS
  end
end
