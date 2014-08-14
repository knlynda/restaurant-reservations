class TablesController < ApplicationController
  def index
    @tables = Table.all
  end

  def show
    @table = Table.find(params[:id])
  end

  def new
    @table = Table.new
  end

  def create
    @table = Table.new(table_params)

    if @table.save
      redirect_to tables_path
    else
      redirect_to new_table_path
    end
  end

  def edit
    @table = Table.find(params[:id])
  end

  def update
    @table = Table.find(params[:id])

    if @table.update(table_params)
      redirect_to tables_path
    else
      redirect_to edit_table_path(@table)
    end
  end

  def destroy
    @table = Table.find(params[:id])
    @table.destroy

    redirect_to table_path
  end

  def table_params
    params.require(:table).permit(:number)
  end
end