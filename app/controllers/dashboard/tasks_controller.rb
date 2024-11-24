module Dashboard
    class TasksController < BaseController
        load_and_authorize_resource
        include ActionView::Helpers::SanitizeHelper

        rescue_from CanCan::AccessDenied do |exception|
            redirect_to not_authorized_dashboard_tasks_path, alert: "You are not authorized to perform this action."
        end

        # GET /tasks/search
        def search
          index
          render :index
        end

        # GET /tasks or /tasks.json
        def index
          @tasks = Task.accessible_by(current_ability)
          @q = @tasks.ransack(params[:q])
          @tasks = @q.result(distinct: true).page(params[:page]).per(15)
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
          # Only allow a list of trusted parameters through.
          def task_params
            params.require(:task).permit(:title, :description, :due_date, :status, :category)
          end
    end   
end