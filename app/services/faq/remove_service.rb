module FaqModule
  class RemoveService
    def initialize(params)
      @params = params
      @id = params['id']
    end

    def call
      faq = Faq.where(id: @id).last
      return 'Questão inválida, verifique o Id' if faq.nil?

      Faq.transaction do
        # Deleta as tags associadas que não estejam associadas a outros faqs
        faq.hashtags.each do |h|
          h.delete if h.faqs.count <= 1
        end
        faq.delete
        'Deletado com sucesso'
      end
    end
  end
end
