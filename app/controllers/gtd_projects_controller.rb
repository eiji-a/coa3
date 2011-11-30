class GtdProjectsController < ApplicationController
  def index
  end

  def list
  end

  def show
    @project = GtdProject.new(Content.find(params[:id]))
    @actions = []
    @attached = []
    @project.content.children.each do |c|
      if c.mimetype == GtdAction.mimetype
        @actions << GtdAction.new(c)
      else
        @attached << c
      end
    end
    @title = @project.title
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

end
