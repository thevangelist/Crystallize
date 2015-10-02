require "pdfkit"

module Printer
  def self.create_pdf(html)
    kit = PDFKit.new(html, :page_size => "A4")
    timestamp = Time.now.strftime('%Y%m%d-%H%M%S')
    kit.to_file("files/submission-#{timestamp}.pdf")
  end
end
