require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    def set_locale
      super
    end

    def after_sign_out_path_for(resource)
      super resource
    end

    def after_sign_in_path_for(resource)
      super resource
    end

    def authenticate_user!
      super
    end
  end

  let(:new_user) { create(:user) }

  describe "#set_locale" do
    # ユーザーのlocaleが設定されている
    it "redirect to root_path" do
      @request.env["HTTP_ACCEPT_LANGUAGE"] = :ja
      controller.set_locale
      expect(I18n.locale).to eq(:ja)
    end
  end

  describe "#after_sign_out_path_for" do
    # ログアウトするとrootにリダイレクト
    it "redirect to root_path" do
      expect(controller.after_sign_out_path_for(new_user)).to eq(root_path)
    end
  end

  describe "#after_sign_in_path_for" do
    # ログインするとcalendar_index_pathにリダイレクト
    it "redirect to root_path" do
      expect(controller.after_sign_in_path_for(new_user)).to eq(calendar_index_path)
    end
  end

  describe "#authenticate_user!" do
    # ログインしているとそのまま
    describe "current sign in" do
      login_user
      it "show flash" do
        controller.authenticate_user!
        expect(@flashes).to be_nil
      end
    end

    # ログインしていないとrootにリダイレクト
    # describe "current sign in" do
    #   # login_user
    #   # logout_user
    #   it "show flash" do
    #     controller.authenticate_user!
    #     expect(@flashes.alert).to eq(I18n.t("devise.failure.unauthenticated"))
    #   end
    # end
  end
end
