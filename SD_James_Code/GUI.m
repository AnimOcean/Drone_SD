classdef GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure             matlab.ui.Figure
        UIAxes               matlab.ui.control.UIAxes
        DVisualButtonGroup   matlab.ui.container.ButtonGroup
        RGBButton            matlab.ui.control.RadioButton
        IRButton             matlab.ui.control.RadioButton
        AnalysisButtonGroup  matlab.ui.container.ButtonGroup
        OnButton             matlab.ui.control.RadioButton
        OffButton            matlab.ui.control.RadioButton
        CalibrateButton      matlab.ui.control.Button
        CalibrateButton_2    matlab.ui.control.Button
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Color = [0.8 0.8 0.8];
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.BoxStyle = 'full';
            app.UIAxes.XColor = 'none';
            app.UIAxes.YColor = 'none';
          %  app.UIAxes.ZColor = 'none';
            app.UIAxes.BackgroundColor = [0.8 0.8 0.8];
            app.UIAxes.Position = [1 110 495 371];

            % Create DVisualButtonGroup
            app.DVisualButtonGroup = uibuttongroup(app.UIFigure);
            app.DVisualButtonGroup.Title = '3D-Visual';
            app.DVisualButtonGroup.BackgroundColor = [0.902 0.902 0.902];
            app.DVisualButtonGroup.Position = [518 352 100 79];

            % Create RGBButton
            app.RGBButton = uiradiobutton(app.DVisualButtonGroup);
            app.RGBButton.Text = 'RGB';
            app.RGBButton.Position = [11 33 58 15];
            app.RGBButton.Value = true;

            % Create IRButton
            app.IRButton = uiradiobutton(app.DVisualButtonGroup);
            app.IRButton.Text = 'IR';
            app.IRButton.Position = [11 11 65 15];

            % Create AnalysisButtonGroup
            app.AnalysisButtonGroup = uibuttongroup(app.UIFigure);
            app.AnalysisButtonGroup.Title = 'Analysis';
            app.AnalysisButtonGroup.BackgroundColor = [0.902 0.902 0.902];
            app.AnalysisButtonGroup.Position = [518 202 100 79];

            % Create OnButton
            app.OnButton = uiradiobutton(app.AnalysisButtonGroup);
            app.OnButton.Text = 'On';
            app.OnButton.Position = [11 33 58 15];
            app.OnButton.Value = true;

            % Create OffButton
            app.OffButton = uiradiobutton(app.AnalysisButtonGroup);
            app.OffButton.Text = 'Off';
            app.OffButton.Position = [11 11 65 15];

            % Create CalibrateButton
            app.CalibrateButton = uibutton(app.UIFigure, 'push');
            app.CalibrateButton.BackgroundColor = [1 1 1];
            app.CalibrateButton.Position = [21 31 186 34];
            app.CalibrateButton.Text = 'Calibrate';

            % Create CalibrateButton_2
            app.CalibrateButton_2 = uibutton(app.UIFigure, 'push');
            app.CalibrateButton_2.BackgroundColor = [1 1 1];
            app.CalibrateButton_2.Position = [310 31 186 34];
            app.CalibrateButton_2.Text = 'Calibrate';
        end
    end

    methods (Access = public)

        % Construct app
        function app = GUI

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end