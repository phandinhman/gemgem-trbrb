class ThingsController < ApplicationController
  respond_to :html

  def new
    form Thing::Create
  end

  def create
    run Thing::Create do |op|
      return redirect_to op.model
    end

    render action: :new
  end

  def edit
    form Thing::Update

    render action: :new
  end

  def update
    run Thing::Update do |op|
      return redirect_to op.model
    end

    render action: :new
  end

  def show
    @thing_op = present Thing::Update
    @thing    = @thing_op.model

    form Comment::Create # overrides @model and @form!
  end

  def create_comment
    @thing_op = present Thing::Update
    @thing    = @thing_op.model

    run Comment::Create, params: params.merge(thing_id: params[:id]) do |op| # overrides @model and @form!
      flash[:notice] = "Created comment for \"#{op.thing.name}\""
      return redirect_to thing_path(op.thing)
    end

    render :show
  end

  protect_from_forgery except: :next_comments # FIXME: this is only required in the test, things_controller_test.
  def next_comments
    present Thing::Update

    render js: concept("comment/cell/grid", @model, page: params[:page]).(:append)
  end
end