class Iugu::AccountDomainsController < Iugu::AccountSettingsController

  def index
    @account = current_user.accounts.find(params[:account_id])
    @account_domains = @account.account_domains.where(:account_id => params[:account_id])
    @account_domain = AccountDomain.new
  end

  def create
    @account = current_user.accounts.find(params[:account_id])
    if @account.account_domains << @domain = AccountDomain.create(params[:account_domain])
      redirect_to account_domains_instructions_path(:account_id => params[:account_id], :domain_id => @domain.id)#, :notice => notice = I18n.t("iugu.notices.domain_created")
    else
      render :index
    end
  end

  def destroy
    begin
      @account = current_user.accounts.find(params[:account_id])
      @domain = @account.account_domains.find(params[:domain_id])
      @domain.destroy
      notice = I18n.t("iugu.notices.domain_destroyed")
    rescue
      notice = I18n.t("iugu.notices.domain_not_found")
    end
    redirect_to account_domains_index_path(params[:account_id]), :notice => notice
  end

  def instructions
    begin
      @account = current_user.accounts.find(params[:account_id])
      @domain = @account.account_domains.find(params[:domain_id])
    rescue
      redirect_to account_domains_index_path(params[:account_id]), :notice => I18n.t("iugu.notices.domain_not_found")
    end
  end

  def verify
    begin
      @account = current_user.accounts.find(params[:account_id])
      @domain = @account.account_domains.find(params[:domain_id])
      if @domain.verify 
        redirect_to account_domains_index_path(params[:account_id]), :notice => I18n.t("iugu.notices.domain_verified")
      else
        redirect_to account_domains_index_path(params[:account_id]), :notice => I18n.t("iugu.notices.domain_not_verified")
      end
    rescue
      redirect_to account_domains_index_path(params[:account_id]), :notice => I18n.t("iugu.notices.domain_not_found")
    end
  end

  def primary
    begin
      @account = current_user.accounts.find(params[:account_id])
      @domain = @account.account_domains.find(params[:domain_id])
      @domain.set_primary
      redirect_to account_domains_index_path(params[:account_id]), :notice => I18n.t("iugu.notices.domain_set_primary")
    rescue
      redirect_to account_domains_index_path(params[:account_id]), :notice => I18n.t("iugu.notices.domain_not_found")
    end
  end
  
end
