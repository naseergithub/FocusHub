module Dashboard
    class TasksController < BaseController
      include ActionView::Helpers::SanitizeHelper

        before_action :set_task, only: %i[ show edit update destroy ]
      
        # GET /tasks or /tasks.json
        def search
          @tasks = params.has_key?(:q) ? Task.search(remove_tags(filter_search_query)) : []
          render 'index'
        end

        # GET /tasks or /tasks.json
        def index
          @tasks = Task.all
        end
      
        # GET /tasks/1 or /tasks/1.json
        def show
        end
      
        # GET /tasks/new
        def new
          @task = Task.new
        end
      
        # GET /tasks/1/edit
        def edit
        end
      
        # POST /tasks or /tasks.json
        def create
          @task = Task.new(task_params)
          @task.user_id = current_user.id
      
          respond_to do |format|
            if @task.save
              format.html { redirect_to dashboard_task_path(@task), notice: "Task was successfully created." }
              format.json { render :show, status: :created, location: dashboard_task_path(@task) }
            else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @task.errors, status: :unprocessable_entity }
            end
          end
        end
      
        # PATCH/PUT /tasks/1 or /tasks/1.json
        def update
          respond_to do |format|
            if @task.update(task_params)
              format.html { redirect_to dashboard_task_path(@task), notice: "Task was successfully updated." }
              format.json { render :show, status: :ok, location: dashboard_task_path(@task) }
            else
              format.html { render :edit, status: :unprocessable_entity }
              format.json { render json: @task.errors, status: :unprocessable_entity }
            end
          end
        end
      
        # DELETE /tasks/1 or /tasks/1.json
        def destroy
          @task.destroy!
      
          respond_to do |format|
            format.html { redirect_to dashboard_tasks_path, status: :see_other, notice: "Task was successfully destroyed." }
            format.json { head :no_content }
          end
        end
      
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_task
            @task = Task.find(params[:id])
          end
      
          # Only allow a list of trusted parameters through.
          def task_params
            params.require(:task).permit(:title, :description, :due_date, :status, :category)
          end

          def filter_search_query
            params.require(:q).permit(:title, :category, :due_date, :status) 
          end
          def remove_tags(query)
            q_params = {}
            query.keys.each{|k| q_params[k] = strip_tags(query[k]) }
            q_params
          end
    end   
end