Admin.controllers :postals do

  get :index do
    @postals = Postal.all
    render 'postals/index'
  end

  get :new do
    @postal = Postal.new
    render 'postals/new'
  end

  post :create do
    @postal = Postal.new(params[:postal])
    if @postal.save
      flash[:notice] = 'Postal was successfully created.'
      redirect url(:postals, :edit, :id => @postal.id)
    else
      render 'postals/new'
    end
  end

  get :edit, :with => :id do
    @postal = Postal.find(params[:id])
    render 'postals/edit'
  end

  put :update, :with => :id do
    @postal = Postal.find(params[:id])
    if @postal.update_attributes(params[:postal])
      flash[:notice] = 'Postal was successfully updated.'
      redirect url(:postals, :edit, :id => @postal.id)
    else
      render 'postals/edit'
    end
  end

  delete :destroy, :with => :id do
    postal = Postal.find(params[:id])
    if postal.destroy
      flash[:notice] = 'Postal was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Postal!'
    end
    redirect url(:postals, :index)
  end
end